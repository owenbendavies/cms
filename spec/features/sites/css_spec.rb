require 'rails_helper'

RSpec.feature 'Site CSS' do
  let(:go_to_url) { '/site/css' }

  authenticated_page login_user: :site_admin, topbar_link: 'CSS', page_icon: 'file' do
    scenario 'adding custom CSS' do
      visit_200_page

      expect(find('pre textarea')['autofocus']).to eq 'autofocus'

      fill_in 'site_css', with: 'body{background-color: red}'
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(current_path).to eq '/home'

      site.reload

      expect(site.stylesheet_filename).to match(/\A[0-9a-f-]+\.css/)

      expect(page).to have_selector "link[href=\"#{site.stylesheet.url}\"]", visible: false

      visit_200_page

      expect(find('pre textarea').text).to eq 'body{background-color: red}'
    end

    scenario 'clicking Cancel' do
      visit_200_page
      click_link 'Cancel'
      expect(current_path).to eq '/home'
    end
  end
end
