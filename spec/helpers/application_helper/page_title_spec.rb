require 'rails_helper'

RSpec.describe ApplicationHelper, '#page_title', type: :helper do
  context 'site with sub title' do
    let(:site) do
      FactoryGirl.build(:site, sub_title: Faker::Company.catch_phrase)
    end

    context 'with content' do
      it 'shows title and content' do
        expect(page_title(site, new_name)).to eq "#{site.name} | #{new_name}"
      end
    end

    context 'blank content' do
      it 'shows title and sub title' do
        expect(page_title(site, '')).to eq "#{site.name} | #{site.sub_title}"
      end
    end

    context 'no content' do
      it 'shows title and sub title' do
        expect(page_title(site, nil)).to eq "#{site.name} | #{site.sub_title}"
      end
    end
  end

  context 'site without sub title' do
    let(:site) { FactoryGirl.build(:site) }

    context 'with content' do
      it 'shows title and content' do
        expect(page_title(site, new_name)).to eq "#{site.name} | #{new_name}"
      end
    end

    context 'no content' do
      it 'shows title' do
        expect(page_title(site, '')).to eq site.name
      end
    end
  end
end
