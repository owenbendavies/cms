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
    navigate_via_topbar menu: 'Site', title: 'Messages', icon: '.fas.fa-envelope.fa-fw'
  end

  scenario 'list of messages' do
    expect(all('table tbody tr').size).to eq 10

    expect(find('table')).to have_table_row(
      'Created at' => 'about a month ago',
      'Name' => messages.first.name,
      'Email' => messages.first.email
    )

    links = table_rows[0].map { |cell| cell.find('a') }
    expect(links.count).to eq 3
    link_locations = links.map { |link| link['href'] }.uniq
    expect(link_locations).to eq ["http://localhost:37511/site/messages/#{messages.first.uid}"]
  end

  scenario 'clicking pagination' do
    expect(page).to have_content messages.first.name
    expect(page).not_to have_content messages.last.name

    click_link 2

    expect(page).not_to have_content messages.first.name
    expect(page).to have_content messages.last.name
  end
end
