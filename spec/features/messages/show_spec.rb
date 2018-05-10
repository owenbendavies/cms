require 'rails_helper'

RSpec.feature 'Message show' do
  let(:date) { Time.zone.now - 1.month - 3.days }
  let(:message) { FactoryBot.create(:message, site: site, created_at: date, updated_at: date) }

  before do
    login_as site_user
    visit "/admin/messages/#{message.uid}"
  end

  scenario 'message' do
    expect(page).to have_header('Message', 'svg.fa-envelope.fa-fw')
    expect(page).to have_content 'about a month ago'
    expect(page).to have_content message.name
    expect(page).to have_content message.email
    expect(page).to have_content message.phone
    expect(page).to have_content message.message
  end
end
