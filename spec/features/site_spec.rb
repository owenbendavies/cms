require 'spec_helper'

describe 'site' do
  include_context 'default_site'
  include_context 'new_fields'

  describe 'edit' do
    let(:go_to_url) { '/site/edit' }

    it_should_behave_like 'restricted page'

    it_behaves_like 'logged in account' do
      it 'has icon' do
        page.should have_selector 'h1 i.icon-cog'
      end

      it 'shoud update site' do
        host_field = find('#site_host')
        host_field.value.should eq 'localhost'
        host_field['disabled'].should eq 'disabled'

        find_field('Name').value.should eq @site.name
        find_field('Name')['autofocus'].should eq 'autofocus'
        find_field('Sub title').value.should eq @site.sub_title
        find_field('Copyright').value.should eq @site.copyright
        find_field('Google Analytics').value.should eq @site.google_analytics

        charity_field = find('#site_charity_number')
        charity_field.value.should eq @site.charity_number
        charity_field['disabled'].should eq 'disabled'

        fill_in 'Name', with: "  #{new_company_name} "
        fill_in 'Sub title', with: "  #{new_catch_phrase} "
        fill_in 'Copyright', with: " #{new_name} "
        fill_in 'Google Analytics', with: "  #{new_google_analytics} "
        click_button 'Update Site'

        current_path.should eq '/home'
        it_should_have_alert_with 'Site successfully updated'

        site = Site.find_by_host!('localhost')
        site.name.should eq new_company_name
        site.sub_title.should eq new_catch_phrase
        site.copyright.should eq new_name
        site.google_analytics.should eq new_google_analytics
        site.updated_by.should eq @account.id
        site.updated_from.should eq '127.0.0.1'
      end

      it 'does not store empty copyright' do
        fill_in 'Copyright', with: ''
        click_button 'Update Site'

        site = Site.find_by_host!('localhost')
        site.copyright.should be_nil
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

        current_path.should eq '/site/edit'
      end
    end
  end

  describe 'css' do
    before do
      site = Site.find_by_host! 'localhost'
      site.stylesheet_filename = ''
      site.save!
    end

    let(:go_to_url) { '/site/css' }

    it_should_behave_like 'restricted page'

    it_behaves_like 'logged in account' do
      it 'has icon' do
        page.should have_selector 'h1 i.icon-file'
      end

      it 'edits the css' do
        find('pre textarea')['autofocus'].should eq 'autofocus'
        fill_in 'site_css', with: 'body{background-color: red}'

        click_button 'Update Site'

        site = Site.find_by_host!('localhost')

        site.stylesheet_filename.
          should eq 'b1192d422b8c8999043c2abd1b47b750.css'

        site.updated_by.should eq @account.id
        site.updated_from.should eq '127.0.0.1'

        it_should_be_on_home_page
        it_should_have_alert_with 'Site successfully updated'

        visit_page '/site/css'
        find('pre textarea').text.should eq "body{background-color: red}"
      end

      it 'has cancel button' do
        click_link 'Cancel'
        it_should_be_on_home_page
      end

      it 'has link in topbar' do
        within('#topbar') do
          click_link 'CSS'
        end

        current_path.should eq '/site/css'
      end
    end
  end
end
