require 'rails_helper'

RSpec.feature 'User timeout', js: false do
  let(:restricted_page) { '/user/edit' }

  after { Timecop.return }

  context 'with logged in site user with remember me' do
    before do
      visit_200_page '/login'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      check 'Remember me'
      click_button 'Login'
    end

    context 'when after less than 2 weeks' do
      before { Timecop.travel Time.zone.now + 13.days }

      scenario 'is logged in' do
        visit_200_page restricted_page
      end
    end

    context 'when after 2 weeks' do
      before { Timecop.travel Time.zone.now + 15.days }

      scenario 'displays 404' do
        visit_404_page restricted_page
      end
    end
  end

  context 'with logged in site user without remember me' do
    before do
      visit_200_page '/login'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'
    end

    context 'when after less than 30 minutes' do
      before { Timecop.travel Time.zone.now + 29.minutes }

      scenario 'displays the page' do
        visit_200_page restricted_page
      end
    end

    context 'when after 30 minutes' do
      before { Timecop.travel Time.zone.now + 31.minutes }

      scenario 'displays 404' do
        visit_404_page restricted_page
      end
    end
  end
end
