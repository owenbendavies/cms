require 'rails_helper'

RSpec.describe ApplicationHelper, '#page_title' do
  let(:site) { FactoryBot.build_stubbed(:site) }

  context 'with content' do
    it 'shows title and content' do
      expect(helper.page_title(site, new_name)).to eq "#{site.name} | #{new_name}"
    end
  end

  context 'without content' do
    it 'shows title' do
      expect(helper.page_title(site, nil)).to eq site.name
    end
  end
end
