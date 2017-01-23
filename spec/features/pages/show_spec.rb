# TODO: refactor

require 'rails_helper'

RSpec.feature 'Showing a page' do
  scenario 'visiting the page' do
    visit_200_page '/home'

    expect(find('body')['id']).to eq 'cms-page-home'

    within 'article' do
      expect(page).to have_content 'Home'
      expect(body).to include home_page.html_content
      expect(body).to include home_page.custom_html
    end

    within 'footer' do
      date = home_page.updated_at.to_date.iso8601
      expect(page).to have_content "Page last updated #{date}"
    end
  end

  scenario 'visiting the page with Javascript', js: true do
    Timecop.freeze(Time.zone.now - 1.month - 3.days) do
      home_page.updated_at = Time.zone.now
      home_page.save!
    end

    visit_200_page '/home'

    within 'footer' do
      expect(page).to have_content 'Page last updated about a month ago'
    end
  end

  context 'private page' do
    let!(:private_page) { FactoryGirl.create(:private_page, site: site) }

    let(:go_to_url) { '/private' }

    authenticated_page do
      scenario 'visiting a private page' do
        visit_200_page

        expect(page).to have_selector 'h1 .fa-lock'
      end
    end
  end

  scenario 'page from another site' do
    subject = FactoryGirl.create(:page)

    visit_404_page "/#{subject.url}"
  end
end
