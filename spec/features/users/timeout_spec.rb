require 'rails_helper'

RSpec.feature 'User timeout' do
  let(:go_to_url) { '/user/edit' }
  after { Timecop.return }

  context 'logged in site user with remember me' do
    before do
      visit_200_page '/login'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      check 'Remember me'
      click_button 'Login'
    end

    context 'after less than 2 weeks' do
      before { Timecop.travel Time.zone.now + 13.days }

      scenario 'visiting the page' do
        visit_200_page
      end
    end

    context 'after 2 weeks' do
      before { Timecop.travel Time.zone.now + 15.days }

      scenario 'goes to login when not logged in' do
        unchecked_visit go_to_url
        expect(current_path).to eq '/login'
      end
    end
  end

  context 'logged in site user without remember me' do
    before do
      visit_200_page '/login'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'
    end

    context 'after less than 30 minutes' do
      before { Timecop.travel Time.zone.now + 29.minutes }

      scenario 'visiting the page' do
        visit_200_page
      end
    end

    context 'after 30 minutes' do
      before { Timecop.travel Time.zone.now + 31.minutes }

      scenario 'goes to login when not logged in' do
        unchecked_visit go_to_url
        expect(current_path).to eq '/login'
      end
    end
  end
end
