require 'rails_helper'

RSpec.feature 'Social network links' do
  let(:go_to_url) { '/site/edit' }

  it_behaves_like 'logged in site user' do
    scenario 'adding Facebook link' do
      expect(page).to_not have_selector 'footer #cms-facebook'

      fill_in 'Facebook', with: " #{new_facebook} "
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(page).to have_selector 'footer #cms-facebook a .fa-facebook-official'

      link = "a[href=\"https://www.facebook.com/#{new_facebook}\"]"
      expect(page).to have_selector "footer #cms-facebook #{link}"

      visit_page go_to_url

      expect(find_field('Facebook').value).to eq new_facebook
    end

    scenario 'adding Twitter link' do
      expect(page).to_not have_selector 'footer #cms-twitter'

      fill_in 'Twitter', with: " #{new_twitter} "
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(page).to have_selector 'footer #cms-twitter a .fa-twitter'

      link = "a[href=\"https://twitter.com/#{new_twitter}\"]"
      expect(page).to have_selector "footer #cms-twitter #{link}"

      visit_page go_to_url

      expect(find_field('Twitter').value).to eq new_twitter
    end

    scenario 'adding YouTube link' do
      expect(page).to_not have_selector 'footer #cms-youtube'

      fill_in 'YouTube', with: " #{new_youtube} "
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(page).to have_selector 'footer #cms-youtube a .fa-youtube-play'

      link = "a[href=\"https://www.youtube.com/#{new_youtube}\"]"
      expect(page).to have_selector "footer #cms-youtube #{link}"

      visit_page go_to_url

      expect(find_field('YouTube').value).to eq new_youtube
    end

    scenario 'adding LinkedIn link' do
      expect(page).to_not have_selector 'footer #cms-linkedin'

      fill_in 'LinkedIn', with: "  #{new_linkedin} "
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(page).to have_selector 'footer #cms-linkedin a .fa-linkedin-square'

      link = "a[href=\"https://www.linkedin.com/in/#{new_linkedin}\"]"
      expect(page).to have_selector "footer #cms-linkedin #{link}"

      visit_page go_to_url

      expect(find_field('LinkedIn').value).to eq new_linkedin
    end

    scenario 'adding GitHub link' do
      expect(page).to_not have_selector 'footer #cms-github'

      fill_in 'GitHub', with: "  #{new_github} "
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(page).to have_selector 'footer #cms-github a .fa-github'

      link = "a[href=\"https://github.com/#{new_github}\"]"
      expect(page).to have_selector "footer #cms-github #{link}"

      visit_page go_to_url

      expect(find_field('GitHub').value).to eq new_github
    end
  end
end
