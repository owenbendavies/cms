require 'rails_helper'

RSpec.feature 'List users' do
  let(:go_to_url) { '/site/users' }

  let(:user2) { FactoryGirl.create(:user) }

  before do
    site.users << user2
  end

  it_behaves_like 'restricted page'

  it_behaves_like 'logged in user' do
    scenario 'visiting the page' do
      within '#cms-article' do
        expect(page).to have_content 'Users'
        expect(page).to have_content 'Email'
        expect(page).to have_content user.email
        expect(page).to have_content user2.email
      end
    end

    include_examples 'page with topbar link', 'Users', 'group'
  end
end
