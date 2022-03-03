require 'rails_helper'

RSpec.feature 'Page with contact form' do
  let(:contact_page) { create(:page, contact_form: true, site:) }
  let(:sleep_rate) { InvisibleCaptcha.timestamp_threshold + 1 }

  let(:emails) do
    %w[admin1@example.com admin2@example.com another@example.com siteuser@example.com]
  end

  before do
    visit "/#{contact_page.url}"
    fill_in 'Name', with: "  #{new_name} "
    fill_in 'Email', with: "  #{new_email} "
    fill_in 'Phone', with: " #{new_phone} "
    fill_in 'Message', with: new_message
  end

  scenario 'sending a message' do
    perform_enqueued_jobs do
      sleep sleep_rate
      click_button 'Send Message'

      expect(page).to have_content 'Thank you for your message'
    end

    expect(Message.count).to eq 1

    message = site.messages.first
    expect(message.site).to eq site
    expect(message.name).to eq new_name
    expect(message.email).to eq new_email
    expect(message.phone).to eq new_phone
    expect(message.message).to eq new_message

    email = last_email
    expect(email.from).to eq [site.email]
    expect(email.to).to eq emails
    expect(email.subject).to eq 'New message'
    expect(email.html_part.body).to have_content new_name
    expect(email.html_part.body).to have_content new_email
    expect(email.html_part.body).to have_content new_phone
    expect(email.html_part.body).to have_content new_message
  end

  scenario 'invalid data' do
    fill_in 'Name', with: 'a'
    sleep sleep_rate
    click_button 'Send Message'

    expect(page).to have_content 'Sorry your message was invalid, please fix the problems below'
    expect(page).to have_content "Name\nis too short"
  end

  scenario 'filling in honeypot', js: false do
    fill_in 'message_surname', with: new_name
    sleep sleep_rate
    click_button 'Send Message'

    expect(page).to have_content 'Sorry your message was invalid, please fix the problems below'
  end

  scenario 'filling in too quickly' do
    click_button 'Send Message'

    expect(page).to have_content 'Sorry, that was too quick!'
  end

  context 'when site has privacy policy' do
    let!(:site) { create(:site, :with_privacy_policy, host: Capybara.server_host) }
    let(:privacy_policy_text) { "I agree to #{site.privacy_policy_page.name}" }

    scenario 'when agreeing to privacy policy' do
      check privacy_policy_text
      sleep sleep_rate
      click_button 'Send Message'
      expect(page).to have_content 'Thank you for your message'
    end

    scenario 'when not agreeing to privacy policy', js: false do
      sleep sleep_rate
      click_button 'Send Message'

      expect(page).to have_content 'Sorry your message was invalid, please fix the problems below'
      expect(page).to have_content "#{privacy_policy_text}\ncan't be blank"
    end
  end
end
