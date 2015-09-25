RSpec.configuration.include Warden::Test::Helpers, type: :feature

RSpec.shared_context 'feature helpers', type: :feature do
  alias_method :safe_login_as, :login_as
  alias_method :visit_page, :visit

  def login_as(*_)
    fail 'Please use methods from spec/support/feature_helpers.rb'
  end

  def visit(*_)
    fail 'Please use methods from spec/support/feature_helpers.rb'
  end

  def visit_non_redirect(url)
    visit_page url
    expect(current_path).to eq URI.parse(url).path
  end

  def visit_200_page(url)
    visit_non_redirect url
    expect(page.status_code).to eq 200
  end

  def visit_404_page(url)
    visit_non_redirect url
    expect(page.status_code).to eq 404
    expect(page).to have_content 'Page Not Found'
  end
end

RSpec.configuration.alias_it_should_behave_like_to :as_a, 'as a'

RSpec.shared_context 'logged in admin' do
  before do
    safe_login_as admin
    visit_200_page go_to_url
  end
end

RSpec.shared_context 'logged in site user' do
  before do
    safe_login_as site_user
    visit_200_page go_to_url
  end
end

RSpec.shared_context 'logged in user' do
  before do
    safe_login_as user
    visit_200_page go_to_url
  end
end

RSpec.shared_context 'authenticated page' do
  scenario 'goes to login when not logged in' do
    visit_page go_to_url
    expect(current_path).to eq '/login'
  end
end

RSpec.shared_context 'restricted page' do
  include_examples 'authenticated page'

  scenario 'displays 404 for unauthorized user' do
    safe_login_as user
    visit_404_page go_to_url
  end
end

RSpec.shared_context 'restricted page with topbar link' do |page_title|
  include_examples 'restricted page'

  scenario 'does not have topbar link for unauthorized user' do
    safe_login_as user
    visit_200_page '/home'

    within('#cms-topbar') do
      expect(page).to_not have_link page_title
    end
  end
end

RSpec.shared_context 'page with topbar link' do |page_title, page_icon|
  scenario 'navigating to the page via topbar' do
    visit_200_page '/home'

    expect(page).to have_selector "#cms-topbar .fa-#{page_icon}"

    within '#cms-topbar' do
      click_link page_title
    end

    expect(current_path).to eq go_to_url

    within '#cms-article-header' do
      expect(page).to have_content page_title
      expect(page).to have_selector ".fa-#{page_icon}"
    end
  end
end
