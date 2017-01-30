# TODO: refactor

require 'rails_helper'

RSpec.feature 'User login via email' do
  before do
    visit_200_page '/home'
    click_link 'Login'

    expect(current_path).to eq '/login'
  end

  scenario 'with valid email and password' do
    expect(find_field('Email')['autofocus']).to eq 'autofocus'
    fill_in 'Email', with: user.email
    expect(find_field('Password')['autocomplete']).to eq 'off'
    fill_in 'Password', with: user.password

    click_button 'Login'

    expect(page).to have_content 'Signed in successfully.'
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

    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq '/login'
  end

  scenario 'with invalid password' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: new_password

    click_button 'Login'

    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq '/login'
  end
end
