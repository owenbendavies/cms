#coding: utf-8
require 'spec_helper'

describe ApplicationHelper do
  include_context 'new_fields'

  describe 'page_title' do
    context 'site with sub title' do
      before { @site = FactoryGirl.build(:site) }

      context 'with content' do
        it 'shows title and content' do
          page_title(new_name).should eq "#{@site.name} | #{new_name}"
        end
      end

      context 'blank content' do
        it 'shows title and sub title' do
          page_title('').should eq "#{@site.name} | #{@site.sub_title}"
        end
      end

      context 'no content' do
        it 'shows title and sub title' do
          page_title(nil).should eq "#{@site.name} | #{@site.sub_title}"
        end
      end
    end

    context 'site without sub title' do
      before { @site = FactoryGirl.build(:site, sub_title: nil) }

      context 'with content' do
        it 'shows title and content' do
          page_title(new_name).should eq "#{@site.name} | #{new_name}"
        end
      end

      context 'no content' do
        it 'shows title' do
          page_title('').should eq @site.name
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
        footer_copyright.should include "#{@site.copyright} © 2012"

        footer_copyright.should include(
          "Registered charity number #{@site.charity_number}"
        )
      end
    end

    context 'site without copyright' do
      before { @site.copyright = nil }

      it 'uses site name for copyright' do
        footer_copyright.should include "#{@site.name} © 2012"
      end
    end

    context 'site without charity number' do
      before { @site.charity_number = nil }

      it 'does not show charity number' do
        footer_copyright.should eq "#{@site.copyright} © 2012"
      end
    end
  end
end
