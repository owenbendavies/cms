#coding: utf-8
require 'rails_helper'

RSpec.describe 'application layout', type: :feature do
  it_behaves_like 'non logged in account' do
    before do
      site.main_menu_page_ids = [home_page.id, test_page.id]
      site.save!

      visit_page '/test_page'
    end

    it 'has no topbar' do
      expect(page).to have_no_selector '#topbar'
    end

    it 'has title' do
      expect(find('title', visible: false).native.text).
        to eq "#{site.name} | Test Page"
    end

    it 'has site stylesheet' do
      link = "link[href=\"#{site.stylesheet.url}\"]"
      expect(page).to have_selector link, visible: false
    end

    it 'has google analytics' do
      expect(body).to include(
        "ga('create', '#{site.google_analytics}', 'localhost');"
      )
    end

    it 'does not have google analytics uid' do
      expect(body).to_not include('&uid')
    end

    it 'has header image' do
      image = page.find('h1#site_name a[href="/home"] img')
      expect(image['src']).to eq site.header_image.span12.url
      expect(image['alt']).to eq site.name
    end

    it 'has sub title' do
      expect(find('h2#site_sub_title').text).to eq site.sub_title
    end

    it 'has main menu' do
      expect(page).to have_link 'Home', href: '/home'
      expect(page).to have_link 'Test Page', href: '/test_page'
    end

    it 'has page last updated in footer' do
      within 'footer' do
        expect(find('#last_update').text).
          to eq "Page last updated #{test_page.updated_at.to_date.iso8601}"
      end
    end

    it 'last updated should be in words', js: true do
      Timecop.freeze(Time.now - 1.month - 3.days) do
        test_page.updated_at = Time.now
        test_page.save!
      end

      visit_page '/test_page'

      within 'footer' do
        expect(find('#last_update').text).
          to eq 'Page last updated about a month ago'
      end
    end

    it 'has copyright in footer' do
      within 'footer' do
        expect(find('#copyright').text).
          to include "#{site.copyright} © #{Time.now.year}"
      end
    end
  end

  it_behaves_like 'logged in account' do
    describe 'topbar' do
      let(:topbar) { find('#topbar') }

      it 'has link to home' do
        expect(topbar).to have_link site.name, href: '/'
      end

      it 'has google analytics uid' do
        expect(body).to include("ga('set', '&uid', '#{account.id}');")
      end

      it 'has gravatar image' do
        within '#topbar' do
          image = find('img')
          expect(image['src']).to eq account.gravatar_url
          expect(image['alt']).to eq 'Profile Image'
        end
      end
    end
  end
end
