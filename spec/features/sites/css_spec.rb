require 'rails_helper'

RSpec.feature 'Site CSS' do
  let(:go_to_url) { '/site/css' }

  it_behaves_like 'restricted page'

  it_behaves_like 'logged in user' do
    scenario 'adding custom CSS' do
      expect(find('pre textarea')['autofocus']).to eq 'autofocus'

      fill_in 'site_css', with: 'body{background-color: red}'
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(current_path).to eq '/home'

      site.reload

      expect(site.stylesheet_filename)
        .to eq 'b1192d422b8c8999043c2abd1b47b750.css'

      expect(site.updated_by).to eq user

      link = "link[href=\"#{site.stylesheet.url}\"]"
      expect(page).to have_selector link, visible: false

      visit_page '/site/css'

      expect(find('pre textarea').text).to eq 'body{background-color: red}'
    end

    scenario 'clicking Cancel' do
      click_link 'Cancel'
      expect(current_path).to eq '/home'
    end

    include_examples 'page with topbar link', 'CSS', 'file'
  end
end
