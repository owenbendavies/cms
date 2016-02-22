RSpec.configuration.include Warden::Test::Helpers, type: :feature

RSpec.shared_context 'feature helpers', type: :feature do
  alias_method :unchecked_login_as, :login_as
  alias_method :unchecked_visit, :visit

  def login_as(*_)
    raise 'Please use methods from spec/support/feature_helpers.rb'
  end

  def visit(*_)
    raise 'Please use methods from spec/support/feature_helpers.rb'
  end

  def visit_non_redirect(url = go_to_url)
    unchecked_visit url
    expect(current_path).to eq URI.parse(url).path
  end

  def visit_200_page(url = go_to_url)
    visit_non_redirect url
    expect(page.status_code).to eq 200
  end

  def visit_404_page(url = go_to_url)
    visit_non_redirect url
    expect(page.status_code).to eq 404
    expect(page).to have_content 'Page Not Found'
  end
end

RSpec.shared_context 'unauthenticated user' do
  scenario 'displays 404' do
    visit_404_page
  end
end

RSpec.shared_context 'unauthorized user' do |topbar_link|
  before do
    unchecked_login_as user
  end

  scenario 'displays 404' do
    visit_404_page
  end

  if topbar_link
    scenario 'does not have topbar link' do
      visit_200_page '/home'

      within('#cms-topbar') do
        expect(page).not_to have_link topbar_link
      end
    end
  end
end

RSpec.shared_context 'authorized user' do |login_user, page_title, page_icon|
  before do
    unchecked_login_as send(login_user || :site_user)
  end

  if page_title
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
end

RSpec.configuration.alias_it_should_behave_like_to :as_a, 'as a'

def authenticated_page(login_user: :site_user, topbar_link: nil, page_icon: nil, &block)
  as_a 'unauthenticated user'

  as_a 'unauthorized user', topbar_link unless login_user == :user

  as_a 'authorized user', login_user, topbar_link, page_icon, &block
end
