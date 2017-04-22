require 'rails_helper'

RSpec.feature 'Message show' do
  let(:date) { Time.zone.now - 1.month - 3.days }
  let(:message) { FactoryGirl.create(:message, site: site, created_at: date, updated_at: date) }

  before do
    login_as site_user
    visit_200_page "/site/messages/#{message.uuid}"
  end

  scenario 'message' do
    expect(page).to have_header('Message', 'envelope')
    expect(page).to have_content 'about a month ago'
    expect(page).to have_content message.name
    expect(page).to have_content message.email
    expect(page).to have_content message.phone
    expect(page).to have_content message.message
  end
end
