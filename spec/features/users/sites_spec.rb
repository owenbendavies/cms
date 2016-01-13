require 'rails_helper'

RSpec.feature 'User sites' do
  let(:go_to_url) { '/user/sites' }
  let(:link_title) { 'localhost' }
  let(:link_href) { 'https://localhost' }

  include_examples 'authenticated page'

  as_a 'logged in user' do
    scenario 'visiting the page' do
      expect(page).to_not have_link link_title, href: link_href
    end
  end

  as_a 'logged in site user' do
    scenario 'visiting the page' do
      expect(page).to have_link link_title, href: link_href
    end

    include_examples 'page with topbar link', 'Sites', 'list'
  end
end
