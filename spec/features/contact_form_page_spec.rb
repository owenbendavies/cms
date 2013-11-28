require 'spec_helper'

describe 'contact_form page' do
  include_context 'default_site'
  include_context 'new_fields'

  before do
    @contact_page = FactoryGirl.create(:page,
      site_id: @site.id,
      bottom_section: 'contact_form',
    )
  end


  before do
    visit_page "/#{@contact_page.url}"
  end

  it 'sends a message' do
    fill_in 'Name', with: "  #{new_name} "
    fill_in 'Email address', with: "  #{new_email} "
    fill_in 'Phone number', with: " #{new_phone_number} "
    fill_in 'Message', with: new_message

    expect {
      expect {
        click_button 'Send Message'
      }.to change(Message, :count).by(1)
    }.to change{ActionMailer::Base.deliveries.size}.by(1)

    current_path.should eq "/#{@contact_page.url}"
    it_should_have_alert_with 'Thank you for your message'

    message = Message.find_all_by_site(@site).first
    message.site_id.should eq @site.id
    message.name.should eq new_name
    message.email_address.should eq new_email
    message.phone_number.should eq new_phone_number
    message.message.should eq new_message
    message.updated_from.should eq '127.0.0.1'

    last_message = ActionMailer::Base.deliveries.last
    last_message.from.should eq ["noreply@#{@site.host}"]
    last_message.to.should eq [@account.email]
    last_message.subject.should eq @contact_page.name
    last_message.body.should include "Name: #{new_name}"
    last_message.body.should include "Email address: #{new_email}"
    last_message.body.should include "Phone number: #{new_phone_number}"
    last_message.body.should include "Message: #{new_message}"
  end

  it 'does not send a message with invalid data' do
    fill_in 'Email address', with: new_email
    fill_in 'Message', with: new_message

    expect {
      click_button 'Send Message'
    }.to_not change{ActionMailer::Base.deliveries.size}

    current_path.should eq "/#{@contact_page.url}/contact_form"
    it_should_have_form_error "can't be blank"
  end

  it 'does not send a message with do_not_fill_in field' do
    fill_in 'Name', with: new_name
    fill_in 'Email address', with: new_email
    fill_in 'Phone number', with: new_phone_number
    fill_in 'Message', with: new_message
    fill_in 'Do not fill in', with: new_name

    expect {
      click_button 'Send Message'
    }.to_not change{ActionMailer::Base.deliveries.size}

    current_path.should eq "/#{@contact_page.url}/contact_form"

    it_should_have_form_error 'do not fill in'
  end
end
