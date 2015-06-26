require 'rails_helper'

RSpec.feature 'User logout' do
  it_behaves_like 'logged in user' do
    scenario 'clicking topbar link' do
      expect(page).to have_selector '#cms-topbar .fa-sign-out'

      within('#cms-topbar') do
        click_link 'Logout'
      end

      expect(page).to have_content 'Signed out successfully.'
      expect(current_path).to eq '/home'
    end

    scenario 'clicking footer link' do
      within('#cms-footer-links') do
        click_link 'Logout'
      end

      expect(page).to have_content 'Signed out successfully.'
      expect(current_path).to eq '/home'
    end

    context 'user removed from site' do
      let(:go_to_url) { '/home/edit' }

      before do
        user.sites = []
        user.save!
      end

      it_behaves_like 'restricted page'
    end
  end
end
