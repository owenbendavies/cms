module FeatureHelpers
  include Warden::Test::Helpers

  def visit_page(url)
    visit url
    expect(page.status_code).to eq 200
    expect(current_path).to eq url.split('?').first
  end
end

RSpec.configuration.include FeatureHelpers, type: :feature

RSpec.shared_context 'logged in admin' do
  before do
    login_as admin

    if defined? go_to_url
      visit_page go_to_url
    else
      visit_page '/home'
    end
  end
end

RSpec.shared_context 'logged in site user' do
  before do
    login_as site_user

    if defined? go_to_url
      visit_page go_to_url
    else
      visit_page '/home'
    end
  end
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

RSpec.shared_context 'authenticated page' do
  scenario 'goes to login when not logged in' do
    visit go_to_url
    expect(current_path).to eq '/login'
  end
end

RSpec.shared_context 'restricted page' do
  include_examples 'authenticated page'

  scenario 'displays 404 for unauthorized user' do
    login_as user
    visit go_to_url
    expect(page.status_code).to eq 404
    expect(current_path).to eq go_to_url
    expect(page).to have_content 'Page Not Found'
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
