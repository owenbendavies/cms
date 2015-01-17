require 'rails_helper'

RSpec.describe '/users', type: :feature do
  describe '/index' do
    let(:go_to_url) { '/site/users' }

    it_behaves_like 'restricted page'

    it_behaves_like 'logged in user' do
      it 'has list of users' do
        within '#main_article' do
          expect(page).to have_content 'Users'
          expect(page).to have_selector 'h1 .glyphicon-group'

          expect(page).to have_content 'Email'
          expect(page).to have_content user.email
          expect(page).to have_content site.users.second.email
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
