require 'rails_helper'

RSpec.describe ApplicationHelper, '#privacy_policy_link' do
  let(:site) { FactoryBot.build(:site, :with_privacy_policy) }
  let(:privacy_policy) { site.privacy_policy_page }
  let(:link) { "<a target=\"_blank\" href=\"#{href}\">#{privacy_policy.name}</a>" }

  context 'with url false' do
    let(:href) { "/#{privacy_policy.url}" }

    it 'renders path link to privacy_policy' do
      expect(helper.privacy_policy_link(site)).to eq link
    end
  end

  context 'with url true' do
    let(:href) { "http://test.host/#{privacy_policy.url}" }

    it 'renders full url link to privacy_policy' do
      expect(helper.privacy_policy_link(site, url: true)).to eq link
    end
  end
end
