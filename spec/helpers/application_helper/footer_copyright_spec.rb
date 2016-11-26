require 'rails_helper'

RSpec.describe ApplicationHelper, '#footer_copyright' do
  let(:site) do
    FactoryGirl.build(
      :site,
      copyright: Faker::Name.name,
      charity_number: Faker::Number.number(Faker::Number.digit.to_i)
    )
  end

  context 'site with copyright and charity' do
    it 'includes copyright and charity number' do
      expect(footer_copyright(site)).to eq(
        "#{site.copyright} © #{Time.zone.now.year}. " \
        "Registered charity number #{site.charity_number}"
      )
    end
  end

  context 'site without copyright' do
    it 'uses site name for copyright' do
      site.copyright = nil

      expect(footer_copyright(site)).to eq(
        "#{site.name} © #{Time.zone.now.year}. " \
        "Registered charity number #{site.charity_number}"
      )
    end
  end

  context 'site without charity number' do
    it 'does not show charity number' do
      site.charity_number = nil
      footer = footer_copyright(site)

      expect(footer).to eq "#{site.copyright} © #{Time.zone.now.year}"
    end
  end

  context 'site without copyright or charity' do
    it 'does not show charity number' do
      site.copyright = nil
      site.charity_number = nil
      footer = footer_copyright(site)

      expect(footer).to eq "#{site.name} © #{Time.zone.now.year}"
    end
  end
end
