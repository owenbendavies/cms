require 'rails_helper'

RSpec.describe '/site', type: :feature do
  describe '/index' do
    let(:go_to_url) { '/sites' }

    it_behaves_like 'restricted page'

    it_behaves_like 'logged in user' do
      it 'lists the users sites' do
        expect(page).to have_link 'localhost', href: 'http://localhost'
      end

      it 'has link in topbar' do
        visit_page '/home'

        within('#topbar') do
          click_link 'Sites'
        end

        expect(current_path).to eq go_to_url
      end

      it 'has icon on page' do
        expect(page).to have_selector 'h1 .fa-list'
      end

      it 'has icon in topbar' do
        expect(page).to have_selector '#topbar .fa-list'
      end
    end
  end

  describe '/edit' do
    let(:go_to_url) { '/site/edit' }

    it_behaves_like 'restricted page'

    it_behaves_like 'logged in user' do
      it 'updates the site' do
        host_field = find('#site_host')
        expect(host_field.value).to eq 'localhost'
        expect(host_field['disabled']).to eq 'disabled'

        expect(find_field('Name').value).to eq site.name
        expect(find_field('Name')['autofocus']).to eq 'autofocus'
        expect(find_field('Sub title').value).to eq site.sub_title
        expect(find_field('Copyright').value).to eq site.copyright
        expect(find_field('Google Analytics').value).to eq site.google_analytics

        charity_field = find('#site_charity_number')
        expect(charity_field.value).to eq site.charity_number
        expect(charity_field['disabled']).to eq 'disabled'

        expect(find_field('Layout').value).to eq site.layout

        expect(find_field('Display in topbar')).to_not be_checked
        expect(find_field('Display in page')).to be_checked
        expect(find_field('Display in footer')).to_not be_checked

        fill_in 'Name', with: "  #{new_company_name} "
        fill_in 'Sub title', with: "  #{new_catch_phrase} "
        fill_in 'Copyright', with: " #{new_name} "
        fill_in 'Google Analytics', with: "  #{new_google_analytics} "
        select 'Right sidebar', from: 'Layout'

        check 'Display in topbar'
        uncheck 'Display in page'
        check 'Display in footer'

        click_button 'Update Site'

        expect(current_path).to eq '/home'
        it_should_have_success_alert_with 'Site successfully updated'

        site = Site.find_by_host!('localhost')
        expect(site.name).to eq new_company_name
        expect(site.sub_title).to eq new_catch_phrase
        expect(site.copyright).to eq new_name
        expect(site.google_analytics).to eq new_google_analytics
        expect(site.layout).to eq 'right_sidebar'
        expect(site.updated_by).to eq user
        expect(site.main_menu_in_topbar).to eq true
        expect(site.main_menu_in_page).to eq false
        expect(site.main_menu_in_footer).to eq true
      end

      it 'does not store empty copyright' do
        fill_in 'Copyright', with: ''
        click_button 'Update Site'

        site = Site.find_by_host!('localhost')
        expect(site.copyright).to be_nil
      end

      it 'fails with invalid data' do
        fill_in 'Name', with: ''
        click_button 'Update Site'
        it_should_have_form_error "can't be blank"
      end

      it 'has cancel button' do
        click_link 'Cancel'
        it_should_be_on_home_page
      end

      it 'has link in topbar' do
        visit_page '/home'

        within('#topbar') do
          click_link 'Site Settings'
        end

        expect(current_path).to eq go_to_url
      end

      it 'has icon on page' do
        expect(page).to have_selector 'h1 .fa-cog'
      end

      it 'has icon in topbar' do
        expect(page).to have_selector '#topbar .fa-cog'
      end
    end
  end

  describe '/css' do
    before do
      site = Site.find_by_host! 'localhost'
      site.stylesheet_filename = ''
      site.save!
    end

    let(:go_to_url) { '/site/css' }

    it_behaves_like 'restricted page'

    it_behaves_like 'logged in user' do
      it 'edits the css' do
        expect(find('pre textarea')['autofocus']).to eq 'autofocus'
        fill_in 'site_css', with: 'body{background-color: red}'

        click_button 'Update Site'

        site = Site.find_by_host!('localhost')

        expect(site.stylesheet_filename)
          .to eq 'b1192d422b8c8999043c2abd1b47b750.css'

        expect(site.updated_by).to eq user

        it_should_be_on_home_page
        it_should_have_success_alert_with 'Site successfully updated'

        link = "link[href=\"#{site.stylesheet.url}\"]"
        expect(page).to have_selector link, visible: false

        visit_page '/site/css'
        expect(find('pre textarea').text).to eq 'body{background-color: red}'

        site = Site.find_by_host!('localhost')

        expect(site.stylesheet_filename)
          .to eq 'b1192d422b8c8999043c2abd1b47b750.css'

        expect(site.updated_by).to eq user
      end

      it 'has cancel button' do
        click_link 'Cancel'
        it_should_be_on_home_page
      end

      it 'has link in topbar' do
        within('#topbar') do
          click_link 'CSS'
        end

        expect(current_path).to eq go_to_url
      end

      it 'has icon on page' do
        expect(page).to have_selector 'h1 .fa-file'
      end

      it 'has icon in topbar' do
        expect(page).to have_selector '#topbar .fa-file'
      end
    end
  end
end
