module FeatureHelpers
  extend ActiveSupport::Concern
  include Warden::Test::Helpers

  included do
    let!(:user) { FactoryGirl.create(:user) }

    let!(:site) do
      FactoryGirl.create(
        :site,
        host: 'localhost',
        created_by: user,
        updated_at: user
      )
    end

    let!(:home_page) do
      FactoryGirl.create(
        :page,
        name: 'Home',
        site: site,
        created_by: user,
        updated_at: user
      )
    end

    let!(:test_page) do
      FactoryGirl.create(
        :page,
        name: 'Test Page',
        site: site,
        created_at: Time.zone.now,
        updated_at: Time.zone.now,
        created_by: user,
        updated_at: user
      )
    end
  end

  def visit_page(url)
    visit url
    expect(page.status_code).to eq 200
    expect(current_path).to eq url.split('?').first
  end

  RSpec.shared_context 'logged in user' do
    before do
      login_as user

      if defined? go_to_url
        visit_page go_to_url
      else
        visit_page '/home'
      end
    end
  end

  RSpec.shared_context 'non logged in user' do
    before do
      visit_page go_to_url if defined? go_to_url
    end
  end

  RSpec.shared_context 'restricted page' do
    before do
      visit go_to_url
    end

    scenario 'visiting the page while not logged in' do
      expect(current_path).to eq '/login'
    end
  end

  RSpec.shared_context 'page with topbar link' do |page_title, page_icon|
    scenario 'navigating to the page via topbar' do
      visit_page '/home'

      expect(page).to have_selector "#cms-topbar .fa-#{page_icon}"

      within('#cms-topbar') do
        click_link page_title
      end

      expect(current_path).to eq go_to_url

      expect(page).to have_selector "h1 .fa-#{page_icon}"
    end
  end
end

RSpec.configuration.include FeatureHelpers, type: :feature
