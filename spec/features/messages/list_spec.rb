require 'rails_helper'

RSpec.feature 'List messages' do
  let!(:messages) do
    (0..11).map do |i|
      FactoryGirl.create(
        :message,
        created_at: Time.zone.now - 1.month - 3.days - i.minutes,
        updated_at: Time.zone.now - 1.month - 3.days - i.minutes
      )
    end
  end

  let!(:other_site_message) do
    FactoryGirl.create(:message, site: FactoryGirl.create(:site))
  end

  let(:go_to_url) { '/site/messages' }

  authenticated_page topbar_link: 'Messages', page_icon: 'envelope' do
    scenario 'visiting the page', js: true do
      visit_200_page

      expect(table_header_text).to eq ['Created at', 'Name', 'Email']
      expect(table_rows.count).to eq 10

      expect(table_rows[0].map(&:text)).to eq [
        'about a month ago',
        messages.first.name,
        messages.first.email
      ]

      links = table_rows[0].map { |cell| cell.find('a') }
      expect(links.count).to eq 3
      link_locations = links.map { |link| link['href'] }.uniq
      expect(link_locations).to eq ["/site/messages/#{messages.first.id}"]
    end

    scenario 'pagination' do
      visit_200_page

      expect(page).to have_content messages.first.name
      expect(page).not_to have_content messages.last.name

      click_link 2

      expect(page).not_to have_content messages.first.name
      expect(page).to have_content messages.last.name
    end
  end
end
