require 'rails_helper'

RSpec.feature 'User forgot password', js: false do
  before do
    visit_200_page '/login'
    click_link 'Forgot your password?'
  end

  scenario 'resetting password' do
    expect(page).to have_content 'Forgot your password?'

    fill_in 'Email', with: site_user.email
    click_button 'Send reset password instructions'

    expect(page).to have_content 'If your email address exists'

    email = last_email
    expect(email.to).to eq [site_user.email]
    expect(email.subject).to eq 'Reset password instructions'

    visit email.html_part.body.match(/href="([^"]+)/)[1]

    expect(page).to have_content 'Change password'

    expect(find_field('New password')['autocomplete']).to eq 'off'
    expect(find_field('Confirm password')['autocomplete']).to eq 'off'

    fill_in 'New password', with: new_password
    fill_in 'Confirm password', with: new_password
    click_button 'Change password'

    expect(page).to have_content 'Your password has been changed'

    email = last_email
    expect(email.to).to eq [site_user.email]
    expect(email.subject).to eq 'Password Changed'
    site_user.reload

    visit '/logout'
    visit_200_page '/login'
    fill_in 'Email', with: site_user.email
    fill_in 'Password', with: new_password
    click_button 'Login'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'non user' do
    fill_in 'Email', with: new_email
    click_button 'Send reset password instructions'

    expect(page).to have_content 'If your email address exists'
  end
end
