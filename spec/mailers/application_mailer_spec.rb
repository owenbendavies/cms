require 'rails_helper'

RSpec.describe ApplicationMailer do
  subject(:email) { CustomDeviseMailer.confirmation_instructions(user, token) }

  let(:site) { FactoryBot.create(:site) }
  let(:user) { FactoryBot.create(:user, site: site) }
  let(:token) { rand(10_000) }

  it 'has from name as site name' do
    addresses = email.header['from'].address_list.addresses
    expect(addresses.first.display_name).to eq site.name
  end

  it 'has site copyright in body' do
    expect(email.body).to have_content "#{site.name} © #{Time.zone.now.year}"
  end

  describe 'links' do
    context 'with ssl enabled' do
      let(:environment_variables) { { DISABLE_SSL: nil } }

      it 'has https links' do
        expect(email.body).to have_link 'Confirm Email', href: %r{\Ahttps://#{site.host}:37511/}
      end
    end

    context 'with ssl disabled' do
      it 'has http links' do
        expect(email.body).to have_link 'Confirm Email', href: %r{\Ahttp://#{site.host}:37511/}
      end
    end

    context 'with email link port not set' do
      let(:environment_variables) { { EMAIL_LINK_PORT: nil } }

      it 'has no port on links' do
        expect(email.body).to have_link 'Confirm Email', href: %r{\Ahttp://#{site.host}/}
      end
    end
  end

  describe 'charity number' do
    context 'with site with charity number' do
      let(:site) { FactoryBot.create(:site, charity_number: new_number) }

      it 'has charity number in body' do
        expect(email.body).to have_content "Registered charity number #{new_number}"
      end
    end

    context 'with site without charity number' do
      it 'does not have charity number in body' do
        expect(email.body).not_to have_content 'Registered charity'
      end
    end
  end

  context 'when site has privacy policy' do
    let(:site) { FactoryBot.create(:site, :with_privacy_policy) }
    let(:privacy_policy) { site.privacy_policy_page }

    it 'has privacy policy in body' do
      expect(email.body).to have_link(
        privacy_policy.name,
        href: "http://#{site.host}:37511/#{privacy_policy.url}"
      )
    end
  end
end
