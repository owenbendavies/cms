require 'rails_helper'

RSpec.feature 'Showing a page' do
  scenario 'visiting the page' do
    visit_page '/test_page'

    within 'article' do
      expect(page).to have_content 'Test Page'
      expect(body).to include test_page.html_content
    end

    within 'footer' do
      date = test_page.updated_at.to_date.iso8601
      expect(page).to have_content "Page last updated #{date}"
    end
  end

  scenario 'visiting the page with Javascript' do
    Timecop.freeze(Time.zone.now - 1.month - 3.days) do
      test_page.updated_at = Time.zone.now
      test_page.save!
    end

    visit_page '/test_page'

    within 'footer' do
      expect(page).to have_content 'Page last updated about a month ago'
    end
  end

  scenario 'visiting the home page' do
    visit_page '/home'
    expect(page).to have_no_selector 'article header h1'
  end

  context 'private page' do
    let(:private_page) do
      FactoryGirl.create(:page, site: site, private: true)
    end

    let(:go_to_url) { "/#{private_page.url}" }

    it_behaves_like 'restricted page'

    it_behaves_like 'logged in user' do
      scenario 'visiting a private page' do
        expect(page).to have_selector 'h1 .fa-lock'
      end
    end
  end
end
