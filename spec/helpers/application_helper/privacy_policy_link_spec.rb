require 'rails_helper'

RSpec.describe ApplicationHelper, '#privacy_policy_link' do
  let(:site) { FactoryBot.build(:site, :with_privacy_policy) }
  let(:privacy_policy) { site.privacy_policy_page }
  let(:link) { "<a target=\"_blank\" href=\"/#{privacy_policy.url}\">#{privacy_policy.name}</a>" }

  it 'renders link to privacy_policy' do
    expect(helper.privacy_policy_link(site)).to eq link
  end
end
