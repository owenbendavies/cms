RSpec.configuration.include Warden::Test::Helpers, type: :feature

RSpec.shared_context 'authorized user' do |login_user, page_title, page_icon|
  before do
    login_as send(login_user || :site_user)
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
