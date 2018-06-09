require 'rails_helper'

RSpec.describe ApplicationHelper, '#copyright' do
  let(:site) { FactoryBot.build_stubbed(:site) }

  it 'uses site name' do
    expect(copyright(site)).to eq "#{site.name} © #{Time.zone.now.year}"
  end
end
