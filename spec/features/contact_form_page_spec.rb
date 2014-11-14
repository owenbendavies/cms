require 'rails_helper'

RSpec.describe 'contact_form page', type: :feature do
  let!(:contact_page) {
    FactoryGirl.create(:page,
      site_id: site.id,
      contact_form: true,
    )
  }

  before do
    visit_page "/#{contact_page.url}"
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

    expect(current_path).to eq "/#{contact_page.url}"
    it_should_have_alert_with 'Thank you for your message'

    message = Message.find_all_by_site(site).first
    expect(message.site_id).to eq site.id
    expect(message.name).to eq new_name
    expect(message.email_address).to eq new_email
    expect(message.phone_number).to eq new_phone_number
    expect(message.message).to eq new_message

    last_message = ActionMailer::Base.deliveries.last
    expect(last_message.from).to eq ["noreply@#{site.host}"]
    expect(last_message.to).to eq [account.email]
    expect(last_message.subject).to eq contact_page.name
    expect(last_message.body).to include "Name: #{new_name}"
    expect(last_message.body).to include "Email address: #{new_email}"
    expect(last_message.body).to include "Phone number: #{new_phone_number}"
    expect(last_message.body).to include "Message: #{new_message}"
  end

  it 'does not send a message with invalid data' do
    fill_in 'Email address', with: new_email
    fill_in 'Message', with: new_message

    expect {
      expect {
        click_button 'Send Message'
      }.to_not change(Message, :count)
    }.to_not change{ActionMailer::Base.deliveries.size}

    expect(current_path).to eq "/#{contact_page.url}/contact_form"
    it_should_have_form_error "can't be blank"
  end

  it 'does not send a message with do_not_fill_in field' do
    fill_in 'Name', with: new_name
    fill_in 'Email address', with: new_email
    fill_in 'Phone number', with: new_phone_number
    fill_in 'Message', with: new_message
    fill_in 'Do not fill in', with: new_name

    expect {
      expect {
        click_button 'Send Message'
      }.to_not change(Message, :count)
    }.to_not change{ActionMailer::Base.deliveries.size}

    expect(current_path).to eq "/#{contact_page.url}/contact_form"
    it_should_have_form_error 'do not fill in'
  end

  it 'saves spam messages' do
    fill_in 'Name', with: new_name
    fill_in 'Email address', with: new_email
    fill_in 'Phone number', with: new_phone_number
    fill_in 'Message', with: new_message
    fill_in 'Do not fill in', with: new_name

    expect {
      expect {
        expect {
          click_button 'Send Message'
        }.to change(SpamMessage, :count).by(1)
      }.to_not change(Message, :count)
    }.to_not change{ActionMailer::Base.deliveries.size}

    expect(current_path).to eq "/#{contact_page.url}/contact_form"
    it_should_have_form_error 'do not fill in'

    spam_message = SpamMessage.all.first
    expect(spam_message.site_id).to eq site.id
    expect(spam_message.name).to eq new_name
    expect(spam_message.email_address).to eq new_email
    expect(spam_message.phone_number).to eq new_phone_number
    expect(spam_message.message).to eq new_message
    expect(spam_message.do_not_fill_in).to eq new_name
  end
end
