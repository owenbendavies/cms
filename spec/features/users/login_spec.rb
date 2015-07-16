require 'rails_helper'

RSpec.feature 'User login' do
  before do
    visit_page '/home'
    click_link 'Login'

    expect(current_path).to eq '/login'
  end

  scenario 'with valid username and password' do
    expect(find_field('Email')['autofocus']).to eq 'autofocus'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_button 'Login'

    expect(page).to have_content 'Signed in successfully.'

    cookie = response_headers['Set-Cookie']
    expect(cookie).to match(/\A_cms_session=[0-9a-f]{32};.*/)
  end

  scenario 'with email with spaces' do
    fill_in 'Email', with: "  #{user.email} "
    fill_in 'Password', with: user.password

    click_button 'Login'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'with email with wrong case' do
    fill_in 'Email', with: user.email.upcase
    fill_in 'Password', with: user.password

    click_button 'Login'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'with invalid email' do
    fill_in 'Email', with: new_email
    fill_in 'Password', with: user.password

    click_button 'Login'

    expect(page).to have_content 'Invalid email or password.'
    expect(current_path).to eq '/login'
  end

  scenario 'with invalid password' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: new_password

    click_button 'Login'

    expect(page).to have_content 'Invalid email or password.'
    expect(current_path).to eq '/login'
  end

  scenario 'with admin' do
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password

    click_button 'Login'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'with user from another site' do
    new_user = FactoryGirl.create(:user)

    fill_in 'Email', with: new_user.email
    fill_in 'Password', with: new_user.password

    click_button 'Login'

    expect(page).to have_content 'Invalid email or password.'
    expect(current_path).to eq '/login'
  end
end
