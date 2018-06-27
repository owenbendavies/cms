require 'rails_helper'

RSpec.feature 'User timeout', js: false do
  let(:not_found) { 'Page Not Found' }

  let(:restricted_page) { '/user/edit' }

  after { Timecop.return }

  before do
    visit '/login'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'
  end

  scenario 'is logged in after less than 2 weeks' do
    Timecop.travel Time.zone.now + 13.days
    visit restricted_page
    expect(page).not_to have_content not_found
  end

  scenario 'is logged out after 2 weeks' do
    Timecop.travel Time.zone.now + 15.days
    visit restricted_page
    expect(page).to have_content not_found
  end
end
