#coding: utf-8
require 'spec_helper'

describe 'application layout' do
  include_context 'default_site'

  it_behaves_like 'non logged in account' do
    before do
      Timecop.freeze('2012-03-20 10:41:02') do
        visit_page '/test_page'
      end
    end

    it 'has no topbar' do
      page.should have_no_selector '#topbar'
    end

    it 'has title' do
      find('title', visible: false).native.text.
        should eq "#{@site.name} | Test Page"
    end

    it 'has site stylesheet' do
      link = "link[href=\"#{@site.stylesheet.url}\"]"
      page.should have_selector link, visible: false
    end

    it 'has google analytics' do
      page.body.should include(
        "_gaq.push(['_setAccount','#{@site.google_analytics}']);"
      )

      page.body.should include "_gaq.push(['_setDomainName','localhost']);"
    end

    it 'has header image' do
      image = page.find('h1#site_name a[href="/home"] img')
      image['src'].should eq @site.header_image.span12.url
      image['alt'].should eq @site.name
    end

    it 'has sub title' do
      find('h2#site_sub_title').text.should eq @site.sub_title
    end

    it 'has main menu' do
      page.should have_link 'Home', href: '/home'
      page.should have_link 'Test Page', href: '/test_page'
    end

    it 'has page last updated in footer' do
      within 'footer' do
        find('#last_update').text.should eq 'Page last updated 2012-03-12'
      end
    end

    it 'last updated should be in words', js: true do
      Timecop.freeze(Time.now - 1.month) do
        @test_page.updated_at = Time.now
        @test_page.save!
      end

      visit_page '/test_page'

      within 'footer' do
        find('#last_update').text.
          should eq 'Page last updated about a month ago'
      end
    end

    it 'has copyright in footer' do
      within 'footer' do
        find('#copyright').text.should include "#{@site.copyright} © 2012"
      end
    end
  end

  it_behaves_like 'logged in account' do
    describe 'topbar' do
      let(:topbar) { find('#topbar') }

      it 'has link to home' do
        topbar.should have_link @site.name, href: '/'
      end

      it 'has gravatar image' do
        within '#topbar' do
          image = find('img')
          image['src'].should eq @account.gravatar_url
          image['alt'].should eq 'Profile Image'
        end
      end
    end
  end
end
