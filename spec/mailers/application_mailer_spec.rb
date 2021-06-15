require 'rails_helper'

RSpec.describe ApplicationMailer do
  subject(:email) { NotificationsMailer.new_message(message) }

  let(:site) { FactoryBot.build(:site) }
  let(:message) { FactoryBot.build(:message, site: site) }

  it 'has from name as site name' do
    addresses = email.header['from'].address_list.addresses
    expect(addresses.first.display_name).to eq site.name
  end

  it 'has site copyright in body' do
    expect(email.body).to have_content "#{site.name} © #{Time.zone.now.year}"
  end

  describe 'links' do
    let(:site) { FactoryBot.create(:site, :with_privacy_policy) }
    let(:privacy_policy) { site.privacy_policy_page }

    context 'with ssl enabled' do
      it 'has https links' do
        allow(Rails.configuration.x).to receive(:disable_ssl).and_return(nil)
        expect(email.body).to have_link(privacy_policy.name, href: "https://#{site.host}/#{privacy_policy.url}")
      end
    end

    context 'with ssl disabled' do
      it 'has http links' do
        expect(email.body).to have_link(privacy_policy.name, href: "http://#{site.host}/#{privacy_policy.url}")
      end
    end

    context 'with email link port set' do
      it 'has no port on links' do
        allow(Rails.configuration.x).to receive(:email_link_port).and_return('3000')
        expect(email.body).to have_link(privacy_policy.name, href: "http://#{site.host}:3000/#{privacy_policy.url}")
      end
    end
  end

  describe 'charity number' do
    context 'with site with charity number' do
      let(:site) { FactoryBot.build(:site, charity_number: new_number) }

      it 'has charity number in body' do
        expect(email.body).to have_content "Registered charity number #{new_number}"
      end
    end

    context 'with site without charity number' do
      let(:site) { FactoryBot.build(:site, charity_number: nil) }

      it 'does not have charity number in body' do
        expect(email.body).not_to have_content 'Registered charity'
      end
    end
  end

  context 'when site has privacy policy' do
    let(:site) { FactoryBot.create(:site, :with_privacy_policy) }
    let(:privacy_policy) { site.privacy_policy_page }

    it 'has privacy policy in body' do
      expect(email.body).to have_link(privacy_policy.name, href: "http://#{site.host}/#{privacy_policy.url}")
    end
  end
end
