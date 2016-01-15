require 'rails_helper'

RSpec.feature 'User forgot password' do
  scenario 'resetting password' do
    visit_200_page '/login'
    click_link 'Forgot your password?'

    expect(page).to have_content 'Forgot your password?'
    expect(current_path).to eq '/user/password/new'

    fill_in 'Email', with: user.email

    click_button 'Send reset password instructions'
    expect(page).to have_content 'If your email address exists'

    expect(ActionMailer::Base.deliveries.size).to eq 0
    Delayed::Worker.new.work_off
    expect(ActionMailer::Base.deliveries.size).to eq 1

    email = ActionMailer::Base.deliveries.last
    expect(email.to).to eq [user.email]
    expect(email.subject).to eq 'Reset password instructions'

    link = email.html_part.body.match(/href="([^"]+)/)[1]
    expect(link).to include site.host

    visit_200_page link

    expect(page).to have_content 'Change password'

    expect(find_field('New password')['autocomplete']).to eq 'off'
    expect(find_field('Confirm password')['autocomplete']).to eq 'off'

    fill_in 'New password', with: new_password
    fill_in 'Confirm password', with: new_password
    click_button 'Change password'

    expect(page).to have_content 'Your password has been changed'

    user.reload

    visit_page '/logout'
    visit_200_page '/login'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: new_password
    click_button 'Login'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'non user' do
    visit_200_page '/login'
    click_link 'Forgot your password?'
    fill_in 'Email', with: new_email
    click_button 'Send reset password instructions'

    expect(page).to have_content 'If your email address exists'

    expect(ActionMailer::Base.deliveries.size).to eq 0
    Delayed::Worker.new.work_off
    expect(ActionMailer::Base.deliveries.size).to eq 0
  end
end
