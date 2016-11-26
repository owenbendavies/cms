RSpec.configuration.include Warden::Test::Helpers, type: :feature

RSpec.shared_context 'feature helpers' do
  alias_method :unchecked_login_as, :login_as

  def login_as(*_)
    raise 'Please use methods from spec/support/feature_helpers.rb'
  end
end

RSpec.configuration.include_context 'feature helpers', type: :feature

def unauthorized_topbar(topbar_link)
  scenario 'does not have topbar link' do
    visit_200_page '/home'

    within('#cms-topbar') do
      expect(page).not_to have_link topbar_link
    end
  end
end

def unauthorized(login_user, topbar_link: nil)
  context "as a #{login_user}" do
    before do
      unchecked_login_as send(login_user)
    end

    scenario 'displays 404' do
      visit_404_page
    end

    unauthorized_topbar(topbar_link) if topbar_link
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
  context 'as a unauthenticated user' do
    scenario 'displays 404' do
      visit_404_page
    end
  end

  unauthorized(:user, topbar_link: topbar_link) unless login_user == :user

  unauthorized(:site_user, topbar_link: topbar_link) if [:site_admin, :sysadmin].include? login_user

  unauthorized(:site_admin, topbar_link: topbar_link) if login_user == :sysadmin

  as_a 'authorized user', login_user, topbar_link, page_icon, &block
end
