require 'rails_helper'

RSpec.feature 'Site CSS' do
  let(:css) { 'body{background-color: red}' }

  before do
    login_as site_admin
    navigate_via_topbar menu: 'Site', title: 'CSS', icon: '.fas.fa-file.fa-fw'
  end

  scenario 'adding custom CSS' do
    expect(find('pre textarea')['autofocus']).to eq 'autofocus'

    fill_in 'site_css', with: css
    click_button 'Update Site'

    expect(page).to have_content 'Site successfully updated'
    uuid = File.basename(site.reload.stylesheet_filename, '.css')
    url = File.join('http://localhost:37511', 'stylesheets', uuid, 'original.css')
    expect(page).to have_selector "link[href=\"#{url}\"]", visible: false

    navigate_via_topbar menu: 'Site', title: 'CSS', icon: '.fas.fa-file.fa-fw'

    expect(find('pre textarea').text).to eq css
  end

  scenario 'clicking Cancel' do
    click_link 'Cancel'
    expect(page).to have_current_path '/home'
  end
end
