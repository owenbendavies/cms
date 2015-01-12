require 'rails_helper'

RSpec.describe 'sessions', type: :feature do
  describe 'login' do
    before do
      visit_page '/login'
    end

    it 'has page url on body' do
      its_body_id_should_be 'page_url_login'
    end

    it 'accepts spaces in email' do
      expect(find_field('Email')['autofocus']).to eq 'autofocus'
      fill_in 'Email', with: "  #{account.email} "
      fill_in 'Password', with: account.password

      click_button 'Login'

      it_should_be_on_home_page
    end

    it 'does not allow invalid password' do
      fill_in 'Email', with: account.email
      fill_in 'Password', with: new_password

      click_button 'Login'

      expect(current_path).to eq '/login'
      it_should_have_error_alert_with 'Invalid email or password'
    end

    it 'has link in footer' do
      visit_page '/home'

      within('#footer_links') do
        click_link 'Login'
      end

      expect(current_path).to eq '/login'
    end

    it_behaves_like 'logged in account' do
      it 'logs you out if removed from site' do
        account.sites = []
        account.save!

        visit '/account/edit'
        expect(current_path).to eq '/login'
      end
    end
  end

  describe 'logout' do
    it_behaves_like 'logged in account' do
      it 'has link in topbar' do
        visit_page '/home'

        within('#topbar') do
          click_link 'Logout'
        end

        it_should_be_on_home_page
      end

      it 'has link in footer' do
        visit_page '/home'

        within('#footer_links') do
          click_link 'Logout'
        end

        it_should_be_on_home_page
      end
    end
  end

  it_behaves_like 'logged in account' do
    let(:go_to_url) { '/account/edit' }

    context 'after 30 days' do
      before do
        Timecop.travel Time.now + 31.days
      end

      after do
        Timecop.return
      end

      it_behaves_like 'restricted page'
    end
  end

  context 'http' do
    it 'sets session cookie as http only' do
      visit_page '/home'

      expect(response_headers['Set-Cookie']).to_not include 'secure'
    end
  end

  context 'https' do
    it 'sets session cookie as https' do
      page.driver.browser.header('X-Forwarded-Proto', 'https')

      visit_page '/home'

      expect(response_headers['Set-Cookie']).to include 'secure'
    end
  end

  it 'stores session data in database' do
    visit_page '/home'
    expect(response_headers['Set-Cookie'])
      .to match(/^_cms_session=[0-9a-f]{32};.*/)
  end
end
