require 'rails_helper'

RSpec.describe ApplicationHelper, '#site_stylesheet' do
  let(:site) { FactoryBot.build(:site) }
  let!(:stylesheet) { FactoryBot.build(:stylesheet, site: site) }

  it 'returns stylesheet path' do
    url = "http://localhost:37511/css/#{site.host}-#{stylesheet.updated_at.to_i}.css"

    expect(helper.site_stylesheet(site)).to eq url
  end
end
