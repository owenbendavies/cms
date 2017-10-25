require 'rails_helper'

RSpec.feature 'Messages index' do
  let!(:messages) do
    (0..11).map do |i|
      FactoryBot.create(
        :message,
        site: site,
        created_at: Time.zone.now - 1.month - 3.days - i.minutes,
        updated_at: Time.zone.now - 1.month - 3.days - i.minutes
      )
    end
  end

  before do
    FactoryBot.create(:message)
    login_as site_user
    navigate_via_topbar menu: 'Site', title: 'Messages', icon: 'envelope'
  end

  scenario 'list of messages' do
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
    expect(link_locations).to eq ["/site/messages/#{messages.first.uuid}"]
  end

  scenario 'clicking pagination' do
    expect(page).to have_content messages.first.name
    expect(page).not_to have_content messages.last.name

    click_link 2

    expect(page).not_to have_content messages.first.name
    expect(page).to have_content messages.last.name
  end
end
