require 'rails_helper'

RSpec.describe 'users', type: :feature do
  include_context 'default_site'

  before do
    @another_account = FactoryGirl.create(:account)
  end

  describe 'index' do
    let(:go_to_url) { '/site/users' }

    it_should_behave_like 'restricted page'

    it_behaves_like 'logged in account' do
      it 'has list of users' do
        within '#main_article' do
          expect(page).to have_content 'Users'
          expect(page).to have_selector 'h1 i.icon-group'

          expect(page).to have_content 'Email'
          expect(page).to have_content @account.email
          expect(page).to have_content @another_account.email
        end
      end

      it 'has link in topbar' do
        visit_page '/home'

        within '#topbar' do
          click_link 'Users'
        end

        expect(current_path).to eq go_to_url
      end
    end
  end
end
