require 'rails_helper'

RSpec.feature 'User sites' do
  let(:go_to_url) { '/user/sites' }
  let(:link_title) { 'localhost' }
  let(:link_href) { 'https://localhost' }

  authenticated_page login_user: :user, topbar_link: 'Sites', page_icon: 'list' do
    scenario 'visiting the page' do
      visit_200_page
      expect(page).not_to have_link link_title, href: link_href
    end
  end

  as_a 'authorized user' do
    scenario 'visiting the page' do
      visit_200_page

      expect(page).to have_link link_title, href: link_href
    end
  end
end
