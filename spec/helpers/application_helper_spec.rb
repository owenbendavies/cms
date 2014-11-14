#coding: utf-8
require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'page_title' do
    context 'site with sub title' do
      before { @site = FactoryGirl.build(:site) }

      context 'with content' do
        it 'shows title and content' do
          expect(page_title(new_name)).to eq "#{@site.name} | #{new_name}"
        end
      end

      context 'blank content' do
        it 'shows title and sub title' do
          expect(page_title('')).to eq "#{@site.name} | #{@site.sub_title}"
        end
      end

      context 'no content' do
        it 'shows title and sub title' do
          expect(page_title(nil)).to eq "#{@site.name} | #{@site.sub_title}"
        end
      end
    end

    context 'site without sub title' do
      before { @site = FactoryGirl.build(:site, sub_title: nil) }

      context 'with content' do
        it 'shows title and content' do
          expect(page_title(new_name)).to eq "#{@site.name} | #{new_name}"
        end
      end

      context 'no content' do
        it 'shows title' do
          expect(page_title('')).to eq @site.name
        end
      end
    end
  end

  describe 'footer_copyright' do
    before { Timecop.freeze('2012-03-12 09:23:05') }
    after { Timecop.return }
    before { @site = FactoryGirl.build(:site) }

    context 'site with copyright and charity' do
      it 'includes copyright and charity number' do
        expect(footer_copyright).to include "#{@site.copyright} © 2012"

        expect(footer_copyright).to include(
          "Registered charity number #{@site.charity_number}"
        )
      end
    end

    context 'site without copyright' do
      before { @site.copyright = nil }

      it 'uses site name for copyright' do
        expect(footer_copyright).to include "#{@site.name} © 2012"
      end
    end

    context 'site without charity number' do
      before { @site.charity_number = nil }

      it 'does not show charity number' do
        expect(footer_copyright).to eq "#{@site.copyright} © 2012"
      end
    end
  end
end
