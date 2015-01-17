# coding: utf-8
require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#page_title' do
    context 'site with sub title' do
      let(:site) { FactoryGirl.build(:site) }

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
      let(:site) { FactoryGirl.build(:site, sub_title: nil) }

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

  describe '#footer_copyright' do
    let(:site) { FactoryGirl.build(:site) }

    context 'site with copyright and charity' do
      it 'includes copyright and charity number' do
        expect(footer_copyright(site))
          .to include "#{site.copyright} © #{Time.now.year}"

        expect(footer_copyright(site)).to include(
          "Registered charity number #{site.charity_number}"
        )
      end
    end

    context 'site without copyright' do
      before { site.copyright = nil }

      it 'uses site name for copyright' do
        expect(footer_copyright(site))
          .to include "#{site.name} © #{Time.now.year}"
      end
    end

    context 'site without charity number' do
      before { site.charity_number = nil }

      it 'does not show charity number' do
        expect(footer_copyright(site))
          .to eq "#{site.copyright} © #{Time.now.year}"
      end
    end
  end
end
