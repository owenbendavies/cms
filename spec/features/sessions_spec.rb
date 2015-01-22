require 'rails_helper'

RSpec.describe 'sessions', type: :feature do
  describe '/login' do
    before do
      visit_page '/login'
    end

    it 'logs in with valid username and password' do
      expect(find_field('Email')['autofocus']).to eq 'autofocus'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password

      click_button 'Login'

      it_should_be_on_home_page
      it_should_have_success_alert_with 'Signed in successfully.'
    end

    it 'accepts spaces in email' do
      fill_in 'Email', with: "  #{user.email} "
      fill_in 'Password', with: user.password

      click_button 'Login'

      it_should_be_on_home_page
      it_should_have_success_alert_with 'Signed in successfully.'
    end

    it 'ignores case for email 'do
      fill_in 'Email', with: user.email.upcase
      fill_in 'Password', with: user.password

      click_button 'Login'

      it_should_be_on_home_page
      it_should_have_success_alert_with 'Signed in successfully.'
    end

    it 'does not allow invalid email' do
      fill_in 'Email', with: new_email
      fill_in 'Password', with: user.password

      click_button 'Login'

      expect(current_path).to eq '/login'
      it_should_have_error_alert_with 'Invalid email or password.'
    end

    it 'does not allow invalid password' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: new_password

      click_button 'Login'

      expect(current_path).to eq '/login'
      it_should_have_error_alert_with 'Invalid email or password.'
    end

    it 'does not allow user from another site' do
      new_user = FactoryGirl.create(:user)

      fill_in 'Email', with: new_user.email
      fill_in 'Password', with: new_user.password

      click_button 'Login'

      expect(current_path).to eq '/login'
      expect(page.status_code).to eq 200
      it_should_have_error_alert_with 'Invalid email or password.'
    end

    it 'locks out user after 5 attempts' do
      4.times do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: new_password
        click_button 'Login'
        it_should_have_error_alert_with 'Invalid email or password.'
      end

      fill_in 'Email', with: user.email
      fill_in 'Password', with: new_password

      expect(ActionMailer::Base.deliveries.size).to eq 0

      click_button 'Login'

      expect(ActionMailer::Base.deliveries.size).to eq 1

      it_should_have_error_alert_with 'Invalid email or password.'

      email = ActionMailer::Base.deliveries.last
      expect(email.from).to eq ["noreply@#{site.host}"]
      expect(email.to).to eq [user.email]
      expect(email.subject).to eq 'Unlock instructions'

      token = user.send_unlock_instructions

      email = ActionMailer::Base.deliveries.last

      link = "http://#{site.host}/users/unlock?unlock_token=#{token}"

      expect(email.body).to have_content 'Your account has been locked'
      expect(email.body).to have_link 'Unlock account', href: link
    end

    it 'has link in footer' do
      visit_page '/home'

      within('#footer_links') do
        click_link 'Login'
      end

      expect(current_path).to eq '/login'
    end
  end

  it_behaves_like 'logged in user' do
    let(:go_to_url) { '/home/edit' }

    context 'user removed from site' do
      before do
        user.sites = []
        user.save!
      end

      it_behaves_like 'restricted page'
    end
  end

  describe 'timeouts' do
    let(:go_to_url) { '/home/edit' }
    after { Timecop.return }

    context 'logged in user with remember me' do
      before do
        visit_page '/login'
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        check 'Remember me'
        click_button 'Login'
      end

      context 'after less than 30 minutes' do
        before { Timecop.travel Time.now + 29.minutes }

        it 'is logged in' do
          visit_page go_to_url
        end
      end

      context 'after less than 2 weeks' do
        before { Timecop.travel Time.now + 13.days }

        it 'is logged in' do
          visit_page go_to_url
        end
      end

      context 'after 2 weeks' do
        before { Timecop.travel Time.now + 15.days }

        it_behaves_like 'restricted page'
      end
    end

    context 'logged in user without remember me' do
      before do
        visit_page '/login'
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Login'
      end

      context 'after less than 30 minutes' do
        before { Timecop.travel Time.now + 29.minutes }

        it 'is logged in' do
          visit_page go_to_url
        end
      end

      context 'after 30 minutes' do
        before { Timecop.travel Time.now + 31.minutes }

        it_behaves_like 'restricted page'
      end
    end
  end

  describe '/logout' do
    let(:go_to_url) { '/home' }

    it_behaves_like 'logged in user' do
      it 'logs out from link in topbar' do
        visit_page '/home'

        within('#topbar') do
          click_link 'Logout'
        end

        it_should_be_on_home_page
        it_should_have_success_alert_with 'Signed out successfully.'
      end

      it 'logs out from link in footer' do
        within('#footer_links') do
          click_link 'Logout'
        end

        it_should_be_on_home_page
        it_should_have_success_alert_with 'Signed out successfully.'
      end

      it 'has icon in topbar' do
        expect(page).to have_selector '#topbar .fa-sign-out'
      end
    end
  end
end
