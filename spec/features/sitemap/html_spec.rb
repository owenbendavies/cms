require 'rails_helper'

RSpec.feature 'HTML sitemap' do
  let!(:private_page) do
    FactoryGirl.create(
      :private_page,
      site: site,
      created_by: admin,
      updated_by: admin
    )
  end

  let(:go_to_url) { '/sitemap' }

  scenario 'visiting the page' do
    visit_page go_to_url

    expect(page).to have_link 'Home', href: '/home'
    expect(page).to have_no_link private_page.name
  end

  scenario 'navigating to the page via footer' do
    visit_page '/home'

    within('#cms-footer-links') do
      click_link 'Sitemap'
    end

    expect(current_path).to eq go_to_url
  end

  it_behaves_like 'logged in user' do
    scenario 'with a private page' do
      find('ul#cms-sitemap li:nth-child(2)').tap do |item|
        expect(item).to have_link private_page.name, href: '/private'
        expect(item).to have_selector '.fa-lock'
      end
    end

    include_examples 'page with topbar link', 'Sitemap', 'sitemap'
  end
end
