require 'rails_helper'

RSpec.describe 'contact_form page', type: :feature do
  let!(:contact_page) {
    FactoryGirl.create(:page, site: site, contact_form: true)
  }

  before do
    visit_page "/#{contact_page.url}"
  end

  it 'sends a message' do
    fill_in 'Name', with: "  #{new_name} "
    fill_in 'Email', with: "  #{new_email} "
    fill_in 'Phone', with: " #{new_phone} "
    fill_in 'Message', with: new_message

    expect {
      expect {
        click_button 'Send Message'
      }.to change(Message, :count).by(1)
    }.to change{ActionMailer::Base.deliveries.size}.by(1)

    expect(current_path).to eq "/#{contact_page.url}"
    it_should_have_alert_with 'Thank you for your message'

    message = site.messages.first
    expect(message.site).to eq site
    expect(message.name).to eq new_name
    expect(message.email).to eq new_email
    expect(message.phone).to eq new_phone
    expect(message.message).to eq new_message

    last_message = ActionMailer::Base.deliveries.last
    expect(last_message.from).to eq ["noreply@#{site.host}"]
    expect(last_message.to).to eq site.accounts.map(&:email).sort
    expect(last_message.subject).to eq contact_page.name
    expect(last_message.body).to include "Name: #{new_name}"
    expect(last_message.body).to include "Email: #{new_email}"
    expect(last_message.body).to include "Phone: #{new_phone}"
    expect(last_message.body).to include "Message: #{new_message}"
  end

  it 'does not send a message with invalid data' do
    fill_in 'Email', with: new_email
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
    fill_in 'Email', with: new_email
    fill_in 'Phone', with: new_phone
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
end
