require 'rails_helper'

describe 'site' do
  include_context 'default_site'
  include_context 'new_fields'

  describe 'edit' do
    let(:go_to_url) { '/site/edit' }

    it_should_behave_like 'restricted page'

    it_behaves_like 'logged in account' do
      it 'has icon' do
        expect(page).to have_selector 'h1 i.icon-cog'
      end

      it 'shoud update site' do
        host_field = find('#site_host')
        expect(host_field.value).to eq 'localhost'
        expect(host_field['disabled']).to eq 'disabled'

        expect(find_field('Name').value).to eq @site.name
        expect(find_field('Name')['autofocus']).to eq 'autofocus'
        expect(find_field('Sub title').value).to eq @site.sub_title
        expect(find_field('Copyright').value).to eq @site.copyright

        expect(find_field('Google Analytics').value).
          to eq @site.google_analytics

        charity_field = find('#site_charity_number')
        expect(charity_field.value).to eq @site.charity_number
        expect(charity_field['disabled']).to eq 'disabled'

        fill_in 'Name', with: "  #{new_company_name} "
        fill_in 'Sub title', with: "  #{new_catch_phrase} "
        fill_in 'Copyright', with: " #{new_name} "
        fill_in 'Google Analytics', with: "  #{new_google_analytics} "
        click_button 'Update Site'

        expect(current_path).to eq '/home'
        it_should_have_alert_with 'Site successfully updated'

        site = Site.find_by_host('localhost')
        expect(site.name).to eq new_company_name
        expect(site.sub_title).to eq new_catch_phrase
        expect(site.copyright).to eq new_name
        expect(site.google_analytics).to eq new_google_analytics
        expect(site.updated_by).to eq @account.id
      end

      it 'does not store empty copyright' do
        fill_in 'Copyright', with: ''
        click_button 'Update Site'

        site = Site.find_by_host('localhost')
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

        expect(current_path).to eq '/site/edit'
      end
    end
  end

  describe 'css' do
    let(:go_to_url) { '/site/css' }

    it_should_behave_like 'restricted page'

    it_behaves_like 'logged in account' do
      it 'has icon' do
        expect(page).to have_selector 'h1 i.icon-file'
      end

      it 'edits the css' do
        expect(find('pre textarea')['autofocus']).to eq 'autofocus'
        fill_in 'site_css', with: 'body{background-color: red}'

        click_button 'Update Site'

        it_should_be_on_home_page
        it_should_have_alert_with 'Site successfully updated'

        link = 'link[href="/stylesheets/b1192d422b8c8999043c2abd1b47b750.css"]'
        expect(page).to have_selector link, visible: false

        visit_page '/site/css'
        expect(find('pre textarea').text).to eq "body{background-color: red}"

        site = Site.find_by_host('localhost')
        expect(site.css_filename).to eq 'b1192d422b8c8999043c2abd1b47b750.css'
        expect(site.updated_by).to eq @account.id
      end

      it 'has cancel button' do
        click_link 'Cancel'
        it_should_be_on_home_page
      end

      it 'has link in topbar' do
        within('#topbar') do
          click_link 'CSS'
        end

        expect(current_path).to eq '/site/css'
      end

      context 'css feature disabled' do
        before do
          @features.edit_css = false
          @features.save!
          visit go_to_url
        end

        it 'retuns page not found' do
          expect(page.status_code).to eq 404
        end

        it 'does not have link in topbar' do
          expect(page).to have_no_link 'CSS'
        end
      end
    end
  end
end
