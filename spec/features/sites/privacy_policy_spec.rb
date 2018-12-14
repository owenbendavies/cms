require 'rails_helper'

RSpec.feature 'Privacy Policy' do
  let(:css_selector) { '.footer__privacy-policy' }

  context 'when site does not have privacy policy' do
    it 'does not display privacy policy' do
      visit '/home'

      expect(page).not_to have_selector css_selector
    end
  end

  context 'when site has privacy policy' do
    let(:site) { FactoryBot.create(:site, :with_privacy_policy, host: '127.0.0.1') }
    let(:privacy_policy) { site.privacy_policy_page }

    it 'shows link to privacy policy' do
      visit '/home'

      within css_selector do
        expect(page).to have_link(privacy_policy.name, href: "/#{privacy_policy.url}")
      end
    end
  end
end
