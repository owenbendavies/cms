require 'rails_helper'

RSpec.describe 'footer', type: :feature do
  it 'has page last updated' do
    visit_page '/test_page'

    within 'footer' do
      date = test_page.updated_at.to_date.iso8601
      expect(page).to have_content "Page last updated #{date}"
    end
  end

  it 'last updated should be in words', js: true do
    visit_page '/test_page'

    Timecop.freeze(Time.zone.now - 1.month - 3.days) do
      test_page.updated_at = Time.zone.now
      test_page.save!
    end

    visit_page '/test_page'

    within 'footer' do
      expect(page).to have_content 'Page last updated about a month ago'
    end
  end
end
