require 'rails_helper'

RSpec.describe ApplicationHelper, '#copyright' do
  context 'with site with copyright' do
    let(:site) { FactoryBot.build(:site, copyright: new_name) }

    it 'uses site copyright' do
      expect(copyright(site)).to eq "#{new_name} © #{Time.zone.now.year}"
    end
  end

  context 'with site without copyright' do
    let(:site) { FactoryBot.build(:site) }

    it 'uses site name' do
      expect(copyright(site)).to eq "#{site.name} © #{Time.zone.now.year}"
    end
  end
end
