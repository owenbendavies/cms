require 'rails_helper'

RSpec.feature 'User timeout', js: false do
  shared_examples 'displays 404' do
    scenario 'displays 404' do
      visit restricted_page
      expect(page).to have_content 'Page Not Found'
    end
  end

  let(:restricted_page) { '/user/edit' }

  after { Timecop.return }

  context 'with logged in site user with remember me' do
    before do
      visit '/login'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      check 'Remember me'
      click_button 'Login'
    end

    context 'when after less than 2 weeks' do
      before { Timecop.travel Time.zone.now + 13.days }

      scenario 'is logged in' do
        visit restricted_page
      end
    end

    context 'when after 2 weeks' do
      before { Timecop.travel Time.zone.now + 15.days }

      include_examples 'displays 404'
    end
  end

  context 'with logged in site user without remember me' do
    before do
      visit '/login'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'
    end

    context 'when after less than 30 minutes' do
      before { Timecop.travel Time.zone.now + 29.minutes }

      scenario 'displays the page' do
        visit restricted_page
      end
    end

    context 'when after 30 minutes' do
      before { Timecop.travel Time.zone.now + 31.minutes }

      include_examples 'displays 404'
    end
  end
end
