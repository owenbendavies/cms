require 'spec_helper'

describe 'users' do
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
          page.should have_content 'Users'
          page.should have_selector 'h1 i.icon-group'

          page.should have_content 'Email'
          page.should have_content @account.email
          page.should have_content @another_account.email
        end
      end

      it 'has link in topbar' do
        visit_page '/home'

        within '#topbar' do
          click_link 'Users'
        end

        current_path.should eq go_to_url
      end
    end
  end
end
