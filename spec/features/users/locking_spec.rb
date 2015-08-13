require 'rails_helper'

RSpec.feature 'User locking' do
  scenario 'after 5 attempts then unlocking' do
    visit_page '/login'

    4.times do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: new_password
      click_button 'Login'
      expect(page).to have_content 'Invalid email or password.'
    end

    fill_in 'Email', with: user.email
    fill_in 'Password', with: new_password

    expect(ActionMailer::Base.deliveries.size).to eq 0

    click_button 'Login'
    expect(page).to have_content 'Invalid email or password.'

    expect(ActionMailer::Base.deliveries.size).to eq 1

    email = ActionMailer::Base.deliveries.last
    expect(email.to).to eq [user.email]
    expect(email.subject).to eq 'Unlock instructions'

    link = email.html_part.body.match(/href="([^"]+)/)[1]
    expect(link).to include site.host

    visit link

    expect(page).to have_content 'Your account has been unlocked'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'resending unlock email' do
    visit_page '/login'

    5.times do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: new_password
      click_button 'Login'
      expect(page).to have_content 'Invalid email or password.'
    end

    expect(ActionMailer::Base.deliveries.size).to eq 1

    visit_page '/users/unlock/new'

    expect(page).to have_content 'Unlock account'

    fill_in 'Email', with: user.email

    expect(ActionMailer::Base.deliveries.size).to eq 1

    click_button 'Resend unlock instructions'

    expect(page).to have_content 'If your account exists'

    expect(ActionMailer::Base.deliveries.size).to eq 2

    email = ActionMailer::Base.deliveries.last
    expect(email.to).to eq [user.email]
    expect(email.subject).to eq 'Unlock instructions'
  end

  scenario 'non user' do
    visit_page '/users/unlock/new'

    fill_in 'Email', with: new_email
    click_button 'Resend unlock instructions'

    expect(page).to have_content 'If your account exists'

    expect(ActionMailer::Base.deliveries.size).to eq 0
  end
end
