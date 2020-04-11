require 'rails_helper'

RSpec.feature 'Admin sites' do
  def navigate_to_admin_sites
    click_link 'Admin'
    click_link 'Sites'
  end

  def navigate_to_edit_site
    navigate_to_admin_sites
    find('span', text: site.name).click
  end

  before do
    login_as site_user
    visit '/home'
  end

  scenario 'list of sites' do
    navigate_to_admin_sites

    within('table tbody tr:nth-child(1)') do
      expect(find('td:nth-child(1)').text).to eq site.name

      within('td:nth-child(2)') do
        expect(page).to have_link(site.address, href: site.address)
      end

      within('td:nth-child(3)') do
        expect(page).to have_link(site.email, href: "mailto:#{site.email}")
      end

      expect(find('td:nth-child(4)').text).to eq site.google_analytics
      expect(find('td:nth-child(5)').text).to eq site.charity_number
    end
  end

  scenario 'changing the name' do
    expect(page).to have_title site.name
    navigate_to_edit_site
    fill_in 'Name', with: new_company_name
    click_save_and_wait_for_update
    visit '/home'
    expect(page).to have_title new_company_name
  end

  scenario 'removing Google Analytics' do
    expect(body).to include "ga('create', '#{site.google_analytics}', 'auto');"
    expect(body).to include "ga('set', 'userId', '#{site_user.id}');"
    navigate_to_edit_site
    fill_in 'Google analytics', with: '', fill_options: { clear: :backspace }
    click_save_and_wait_for_update
    visit '/home'
    expect(body).not_to include 'ga('
  end

  scenario 'removing a charity number' do
    expect(page).to have_content "Registered charity number #{site.charity_number}"
    navigate_to_edit_site
    fill_in 'Charity number', with: '', fill_options: { clear: :backspace }
    click_save_and_wait_for_update
    visit '/home'
    expect(page).not_to have_content 'Registered charity'
  end

  context 'with CSS content' do
    let(:css) { 'body{background-color: red}' }
    let(:css_url) { '/css/b1192d422b8c8999043c2abd1b47b750.css' }

    scenario 'adding custom CSS' do
      navigate_to_edit_site
      click_link 'CSS'
      fill_in 'Css', with: css
      click_save_and_wait_for_update
      visit '/home'
      expect(page).to have_selector "link[href=\"#{css_url}\"]", visible: false
    end
  end

  context 'with main menu' do
    let(:header) { '.header' }
    let(:main_menu_site_name) { '.main-menu__site-name' }
    let(:main_menu_right_links) { '.main-menu__links.ml-auto' }
    let(:main_menu_footer) { '.footer-main-menu' }

    let(:test_page) { FactoryBot.create(:page, name: 'Test Page', site: site) }

    before do
      home_page.insert_at(1)
      test_page.insert_at(2)
    end

    scenario 'removing separate header' do
      expect(page).to have_selector header
      expect(page).not_to have_selector main_menu_site_name
      expect(page).not_to have_selector main_menu_right_links

      navigate_to_edit_site
      find('label', text: 'Separate header').click
      click_save_and_wait_for_update
      visit '/home'

      expect(page).not_to have_selector header
      expect(page).to have_selector main_menu_site_name
      expect(page).to have_selector main_menu_right_links
    end

    scenario 'adding main menu to footer' do
      expect(page).not_to have_selector main_menu_footer
      navigate_to_edit_site
      find('label', text: 'Main menu in footer').click
      click_save_and_wait_for_update
      visit '/home'

      within main_menu_footer do
        expect(page).to have_link 'Home', href: '/home'
        expect(page).to have_selector 'a.cms-page-link-home'
        expect(page).to have_link 'Test Page', href: '/test_page'
        expect(page).to have_selector 'a.cms-page-link-test_page'
      end
    end
  end

  it_behaves_like 'when on mobile' do
    scenario 'navigating to site' do
      click_button 'Account menu'
      click_link 'Admin'
      find('button[title="Open menu"]').click
      click_link 'Sites'

      within('.list-page ul a:nth-child(1)') do
        expect(page).to have_content site.name
        expect(page).to have_content site.address
      end

      find('span', text: site.name).click
      expect(page).to have_content "Site #{site.name}"
    end
  end

  context 'with multiple sites' do
    let(:site) { FactoryBot.create(:site, name: 'Site z', host: Capybara.server_host) }

    let(:sites) do
      ('a'..'k').map do |i|
        FactoryBot.create(:site, name: "Site #{i}", host: "site#{i}.com")
      end
    end

    let(:site_user) { FactoryBot.build(:user, groups: [site.host] + sites.map(&:host)) }

    scenario 'clicking pagination' do
      navigate_to_admin_sites

      expect(page).to have_content sites.first.name
      expect(page).not_to have_content sites.last.name

      expect(all('table tbody tr').size).to eq 10

      click_button 'Next'

      expect(page).not_to have_content sites.first.name
      expect(page).to have_content sites.last.name

      click_button 'Prev'

      expect(page).to have_content sites.first.name
      expect(page).not_to have_content sites.last.name
    end
  end
end
