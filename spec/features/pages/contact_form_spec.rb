require 'rails_helper'

RSpec.feature 'Page with contact form' do
  let!(:contact_page) { FactoryGirl.create(:page, contact_form: true, site: site) }

  before do
    page.driver.header('User-Agent', new_company_name)
    visit_200_page "/#{contact_page.url}"
  end

  scenario 'sending a message' do
    fill_in 'Name', with: "  #{new_name} "
    fill_in 'Email', with: "  #{new_email} "
    fill_in 'Phone', with: " #{new_phone} "
    fill_in 'Message', with: new_message

    click_button 'Send Message'

    expect(page).to have_content 'Thank you for your message'
    expect(current_path).to eq "/#{contact_page.url}"

    expect(Message.count).to eq 1

    message = site.messages.first
    expect(message.site).to eq site
    expect(message.name).to eq new_name
    expect(message.email).to eq new_email
    expect(message.phone).to eq new_phone
    expect(message.message).to eq new_message

    expect(ActionMailer::Base.deliveries.size).to eq 0
    Delayed::Worker.new.work_off
    expect(ActionMailer::Base.deliveries.size).to eq 1

    email = ActionMailer::Base.deliveries.last
    expect(email.from).to eq ["noreply@#{site.host}"]
    expect(email.to).to eq [site_user.email]
    expect(email.subject).to eq contact_page.name
    expect(email.html_part.body).to have_content new_name
    expect(email.html_part.body).to have_content new_email
    expect(email.html_part.body).to have_content new_phone
    expect(email.html_part.body).to have_content new_message
  end

  scenario 'with invalid data' do
    fill_in 'Email', with: new_email
    fill_in 'Message', with: new_message

    click_button 'Send Message'

    expect(page).to have_content 'is too short'
    expect(current_path).to eq "/#{contact_page.url}/contact_form"

    expect(Message.count).to eq 0

    expect(ActionMailer::Base.deliveries.size).to eq 0
    Delayed::Worker.new.work_off
    expect(ActionMailer::Base.deliveries.size).to eq 0
  end

  scenario 'with do_not_fill_in' do
    fill_in 'Name', with: new_name
    fill_in 'Email', with: new_email
    fill_in 'Phone', with: new_phone
    fill_in 'Message', with: new_message
    fill_in 'Do not fill in', with: new_name

    click_button 'Send Message'

    expect(page).to have_content 'do not fill in'
    expect(current_path).to eq "/#{contact_page.url}/contact_form"

    expect(Message.count).to eq 0

    expect(ActionMailer::Base.deliveries.size).to eq 0
    Delayed::Worker.new.work_off
    expect(ActionMailer::Base.deliveries.size).to eq 0
  end
end
