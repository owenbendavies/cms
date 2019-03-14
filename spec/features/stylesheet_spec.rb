require 'rails_helper'

RSpec.feature 'Stylesheet' do
  let(:css) { 'body{background-color: red}' }
  let(:md5) { 'b1192d422b8c8999043c2abd1b47b750' }

  before do
    login_as admin_user
    navigate_via_topbar menu: 'Site', title: 'CSS', icon: 'svg.fa-file.fa-fw'
  end

  scenario 'adding custom CSS' do
    expect(find('pre textarea')['autofocus']).to eq 'true'

    fill_in 'site_css', with: css
    click_button 'Update Site'

    expect(page).to have_content 'Site successfully updated'
    url = "/css/#{site.uid}-#{md5}.css"
    expect(page).to have_selector "link[href=\"#{url}\"]", visible: false

    navigate_via_topbar menu: 'Site', title: 'CSS', icon: 'svg.fa-file.fa-fw'

    expect(find('pre textarea').text).to eq css
  end

  scenario 'clicking Cancel' do
    click_link 'Cancel'
    expect(page).to have_current_path '/home'
  end
end
