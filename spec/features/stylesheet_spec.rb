require 'rails_helper'

RSpec.feature 'Stylesheet' do
  let(:css) { 'body{background-color: red}' }

  before do
    login_as site_admin
    navigate_via_topbar menu: 'Site', title: 'CSS', icon: 'svg.fa-file.fa-fw'
  end

  scenario 'adding custom CSS' do
    expect(find('pre textarea')['autofocus']).to eq 'true'

    fill_in 'stylesheet_css', with: css
    click_button 'Create Stylesheet'

    expect(page).to have_content 'Stylesheet successfully updated'
    url = "/css/#{site.uid}-#{site.stylesheet.updated_at.to_i}.css"
    expect(page).to have_selector "link[href=\"#{url}\"]", visible: false

    navigate_via_topbar menu: 'Site', title: 'CSS', icon: 'svg.fa-file.fa-fw'

    expect(find('pre textarea').text).to eq css
  end

  scenario 'clicking Cancel' do
    click_link 'Cancel'
    expect(page).to have_current_path '/home'
  end
end
