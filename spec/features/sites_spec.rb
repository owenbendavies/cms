require 'rails_helper'

RSpec.describe '/site', type: :feature do
  describe '/index' do
    let(:go_to_url) { '/sites' }

    it_behaves_like 'restricted page'

    it_behaves_like 'logged in user' do
      it 'lists the users sites' do
        expect(page).to have_link 'localhost', href: 'http://localhost'
      end

      include_examples 'page with topbar link', 'Sites', 'list'
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
        expect(find_field('Google Analytics').value).to eq site.google_analytics
        expect(find_field('Layout').value).to eq site.layout
        expect(find_field('Separate header')).to be_checked

        expect(find_field('Copyright').value).to eq site.copyright
        expect(find_field('Charity number').value).to eq site.charity_number
        expect(find_field('Main menu')).to_not be_checked

        fill_in 'Name', with: "  #{new_company_name} "
        fill_in 'Sub title', with: "  #{new_catch_phrase} "
        fill_in 'Google Analytics', with: "  #{new_google_analytics} "
        select 'Right sidebar', from: 'Layout'
        uncheck 'Separate header'

        fill_in 'Copyright', with: " #{new_name} "
        fill_in 'Charity number', with: " #{new_number} "
        check 'Main menu'

        click_button 'Update Site'

        expect(current_path).to eq '/home'
        it_should_have_success_alert_with 'Site successfully updated'

        site = Site.find_by_host!('localhost')
        expect(site.name).to eq new_company_name
        expect(site.sub_title).to eq new_catch_phrase
        expect(site.google_analytics).to eq new_google_analytics
        expect(site.layout).to eq 'right_sidebar'
        expect(site.updated_by).to eq user
        expect(site.separate_header).to eq false

        expect(site.copyright).to eq new_name
        expect(site.charity_number).to eq new_number.to_s
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

      include_examples 'page with topbar link', 'Site Settings', 'cog'
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

      include_examples 'page with topbar link', 'CSS', 'file'
    end
  end
end
