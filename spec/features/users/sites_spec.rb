require 'rails_helper'

RSpec.feature 'User sites' do
  let(:go_to_url) { '/user/sites' }

  include_examples 'authenticated page'

  as_a 'logged in user' do
    scenario 'visiting the page' do
      expect(page).to_not have_link 'localhost', href: 'http://localhost'
    end
  end

  as_a 'logged in site user' do
    scenario 'visiting the page' do
      expect(page).to have_link 'localhost', href: 'http://localhost'
    end

    include_examples 'page with topbar link', 'Sites', 'list'
  end

  as_a 'logged in admin' do
    scenario 'visiting the page' do
      expect(page).to have_link 'localhost', href: 'http://localhost'
    end
  end
end
