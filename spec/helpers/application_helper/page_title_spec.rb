require 'rails_helper'

RSpec.describe ApplicationHelper, '#page_title' do
  context 'with site with sub title' do
    let(:site) do
      FactoryBot.build_stubbed(:site, sub_title: Faker::Company.catch_phrase)
    end

    context 'with content' do
      it 'shows title and content' do
        expect(helper.page_title(site, new_name)).to eq "#{site.name} | #{new_name}"
      end
    end

    context 'with blank content' do
      it 'shows title and sub title' do
        expect(helper.page_title(site, '')).to eq "#{site.name} | #{site.sub_title}"
      end
    end

    context 'without content' do
      it 'shows title and sub title' do
        expect(helper.page_title(site, nil)).to eq "#{site.name} | #{site.sub_title}"
      end
    end
  end

  context 'with site without sub title' do
    let(:site) { FactoryBot.build_stubbed(:site) }

    context 'with content' do
      it 'shows title and content' do
        expect(helper.page_title(site, new_name)).to eq "#{site.name} | #{new_name}"
      end
    end

    context 'without content' do
      it 'shows title' do
        expect(helper.page_title(site, '')).to eq site.name
      end
    end
  end
end
