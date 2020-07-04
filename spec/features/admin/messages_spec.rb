require 'rails_helper'

RSpec.feature 'Admin messages' do
  def navigate_to_admin_messages
    click_link 'Admin'
    click_link 'Messages'
  end

  def navigate_to_show_message
    navigate_to_admin_messages
    find('span', text: message.name).click
  end

  before do
    login_as site_user
    visit '/home'
  end

  context 'with a message' do
    let!(:message) { FactoryBot.create(:message, site: site) }

    let(:created_at) do
      message.created_at.in_time_zone(ENV.fetch('TZ')).strftime('%d/%m/%Y, %H:%M:%S')
    end

    scenario 'list of messages' do
      navigate_to_admin_messages

      within('table tbody tr:nth-child(1)') do
        expect(find('td:nth-child(2)').text).to eq message.name

        within('td:nth-child(3)') do
          expect(page).to have_link(message.email, href: "mailto:#{message.email}")
        end

        expect(find('td:nth-child(4)').text).to eq message.phone
        expect(find('td:nth-child(5)').text).to eq created_at
      end
    end

    scenario 'viewing a message' do
      navigate_to_show_message

      within('.ra-field-name') do
        expect(page).to have_content 'Name'
        expect(page).to have_content message.name
      end

      within('.ra-field-email') do
        expect(page).to have_content 'Email'
        expect(page).to have_link(message.email, href: "mailto:#{message.email}")
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

    scenario 'deleteing a message' do
      navigate_to_show_message
      click_button 'Delete'
      click_button 'Confirm'
      expect(page).to have_content 'Element deleted'
    end

    it_behaves_like 'when on mobile' do
      let(:created_at) do
        message.created_at.in_time_zone(ENV.fetch('TZ')).strftime('%d/%m/%Y')
      end

      scenario 'navigating to message' do
        click_button 'Account menu'
        click_link 'Admin'
        find('button[title="Open menu"]').click
        click_link 'Messages'

        within('.list-page ul a:nth-child(1)') do
          expect(page).to have_content message.name
          expect(page).to have_content message.email
          expect(page).to have_content created_at
        end

        find('span', text: message.name).click
        expect(page).to have_content "Message from #{message.name}"
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

    scenario 'clicking pagination' do
      navigate_to_admin_messages

      expect(page).to have_content messages.first.name
      expect(page).not_to have_content messages.last.name

      expect(all('table tbody tr').size).to eq 10

      click_button 'Next'

      expect(page).not_to have_content messages.first.name
      expect(page).to have_content messages.last.name

      click_button 'Prev'

      expect(page).to have_content messages.first.name
      expect(page).not_to have_content messages.last.name
    end

    scenario 'sorting data' do
      navigate_to_admin_messages

      expect(page).to have_content messages.first.name
      expect(page).not_to have_content messages.last.name

      find('span[data-sort="createdAt"]').click

      expect(page).not_to have_content messages.first.name
      expect(page).to have_content messages.last.name
    end

    scenario 'deleteing messages' do
      navigate_to_admin_messages

      find('table tbody tr:nth-child(1) td:nth-child(1)').click
      find('table tbody tr:nth-child(2) td:nth-child(1)').click
      find('table tbody tr:nth-child(3) td:nth-child(1)').click

      click_button 'Delete'
      click_button 'Confirm'

      expect(page).to have_content '3 elements deleted'
    end
  end
end
