require 'rails_helper'

RSpec.feature 'Page with contact form' do
  let(:contact_page) { FactoryGirl.create(:page, contact_form: true, site: site) }

  before do
    site_user
    visit_200_page "/#{contact_page.url}"
  end

  scenario 'sending a message' do
    fill_in 'Name', with: "  #{new_name} "
    fill_in 'Email', with: "  #{new_email} "
    fill_in 'Phone', with: " #{new_phone} "
    fill_in 'Message', with: new_message

    click_button 'Send Message'

    expect(page).to have_content 'Thank you for your message'

    expect(Message.count).to eq 1

    message = site.messages.first
    expect(message.site).to eq site
    expect(message.name).to eq new_name
    expect(message.email).to eq new_email
    expect(message.phone).to eq new_phone
    expect(message.message).to eq new_message

    email = last_email
    expect(email.from).to eq ["noreply@#{site.host}"]
    expect(email.to).to eq [site_user.email]
    expect(email.subject).to eq contact_page.name
    expect(email.html_part.body).to have_content new_name
    expect(email.html_part.body).to have_content new_email
    expect(email.html_part.body).to have_content new_phone
    expect(email.html_part.body).to have_content new_message
  end

  scenario 'invalid data' do
    fill_in 'Name', with: 'a'
    fill_in 'Email', with: new_email
    fill_in 'Message', with: new_message
    click_button 'Send Message'

    expect(page).to have_content 'Name is too short'
  end

  scenario 'filling in do_not_fill_in', js: false do
    fill_in 'Name', with: new_name
    fill_in 'Email', with: new_email
    fill_in 'Message', with: new_message
    fill_in 'Do not fill in', with: new_name
    click_button 'Send Message'

    expect(page).to have_content 'do not fill in'
  end
end
