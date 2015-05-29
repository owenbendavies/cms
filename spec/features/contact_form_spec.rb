require 'rails_helper'

RSpec.describe '/contact_form', type: :feature do
  let!(:contact_page) do
    FactoryGirl.create(:page, site: site, contact_form: true)
  end

  before do
    visit_page "/#{contact_page.url}"
  end

  it 'sends a message' do
    fill_in 'Name', with: "  #{new_name} "
    fill_in 'Email', with: "  #{new_email} "
    fill_in 'Phone', with: " #{new_phone} "
    fill_in 'Message', with: new_message

    click_button 'Send Message'

    expect(Message.count).to eq 1
    expect(ActionMailer::Base.deliveries.size).to eq 1

    expect(current_path).to eq "/#{contact_page.url}"
    expect(page).to have_content 'Thank you for your message'

    message = site.messages.first
    expect(message.site).to eq site
    expect(message.name).to eq new_name
    expect(message.email).to eq new_email
    expect(message.phone).to eq new_phone
    expect(message.message).to eq new_message

    email = ActionMailer::Base.deliveries.last
    expect(email.from).to eq ["noreply@#{site.host}"]
    expect(email.to).to eq site.users.map(&:email).sort
    expect(email.subject).to eq contact_page.name
    expect(email.html_part.body).to have_content "Name: #{new_name}"
    expect(email.html_part.body).to have_content "Email: #{new_email}"
    expect(email.html_part.body).to have_content "Phone: #{new_phone}"
    expect(email.html_part.body).to have_content "Message: #{new_message}"
  end

  it 'does not send a message with invalid data' do
    fill_in 'Email', with: new_email
    fill_in 'Message', with: new_message

    click_button 'Send Message'

    expect(Message.count).to eq 0
    expect(ActionMailer::Base.deliveries.size).to eq 0
    expect(current_path).to eq "/#{contact_page.url}/contact_form"
    expect(page).to have_content "can't be blank"
  end

  it 'does not send a message with do_not_fill_in field' do
    fill_in 'Name', with: new_name
    fill_in 'Email', with: new_email
    fill_in 'Phone', with: new_phone
    fill_in 'Message', with: new_message
    fill_in 'Do not fill in', with: new_name

    click_button 'Send Message'

    expect(Message.count).to eq 0
    expect(ActionMailer::Base.deliveries.size).to eq 0
    expect(current_path).to eq "/#{contact_page.url}/contact_form"
    expect(page).to have_content 'do not fill in'
  end
end
