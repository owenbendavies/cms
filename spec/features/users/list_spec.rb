require 'rails_helper'

RSpec.feature 'List users' do
  let(:go_to_url) { '/site/users' }

  it_behaves_like 'restricted page'

  it_behaves_like 'logged in user' do
    scenario 'visiting the page' do
      within '#cms-article' do
        expect(page).to have_content 'Users'
        expect(page).to have_content 'Email'
        expect(page).to have_content admin.email
        expect(page).to have_content user.email
      end
    end

    include_examples 'page with topbar link', 'Users', 'group'
  end
end
