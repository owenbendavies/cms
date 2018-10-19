require 'rails_helper'

RSpec.feature 'Messages' do
  context 'with a message' do
    let!(:message) do
      FactoryBot.create(:message, site: site)
    end

    let(:created_at) do
      message.created_at.in_time_zone(ENV.fetch('TZ')).strftime('%d/%m/%Y, %H:%M:%S')
    end

    before do
      login_as site_user
      visit '/home'
      click_link 'Admin'
      click_link 'Messages'
    end

    scenario 'list of messages' do
      within('table tbody tr:nth-child(1)') do
        expect(find('td:nth-child(1)').text).to eq message.name
        expect(find('td:nth-child(2)').text).to eq message.email
        expect(find('td:nth-child(3)').text).to eq message.phone
        expect(find('td:nth-child(4)').text).to eq created_at
      end
    end

    scenario 'viewing a message' do
      find('table tbody tr:nth-child(1)').click

      within('.ra-field-name') do
        expect(page).to have_content 'Name'
        expect(page).to have_content message.name
      end

      within('.ra-field-email') do
        expect(page).to have_content 'Email'
        expect(page).to have_content message.email
      end

      within('.ra-field-phone') do
        expect(page).to have_content 'Phone'
        expect(page).to have_content message.phone
      end

      within('.ra-field-createdAt') do
        expect(page).to have_content 'Created at'
        expect(page).to have_content created_at
      end

      within('.ra-field-message') do
        expect(page).to have_content 'Message'
        expect(page).to have_content message.message
      end
    end
  end

  context 'with multiple messages' do
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
      login_as site_user
      visit '/home'
      click_link 'Admin'
      click_link 'Messages'
    end

    scenario 'clicking pagination' do
      expect(all('table tbody tr').size).to eq 10

      expect(page).to have_content messages.first.name
      expect(page).not_to have_content messages.last.name

      click_button 'Next'

      expect(page).not_to have_content messages.first.name
      expect(page).to have_content messages.last.name

      click_button 'Prev'

      expect(page).to have_content messages.first.name
      expect(page).not_to have_content messages.last.name
    end
  end
end
