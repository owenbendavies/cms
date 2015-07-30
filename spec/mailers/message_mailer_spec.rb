require 'rails_helper'

RSpec.describe MessageMailer, type: :feature do
  describe '.new_message' do
    let(:admin) { FactoryGirl.create(:admin) }

    let(:site) { FactoryGirl.create(:site) }

    let(:user) { FactoryGirl.create(:user) }

    before do
      SiteSetting.create(
        user: user,
        site: site,
        created_by: admin,
        updated_by: admin
      )
    end

    let(:message) { FactoryGirl.create(:message, site: site) }

    subject { described_class.new_message(message) }

    include_examples 'site email'

    it 'is sent to admins and sites user email' do
      expect(subject.to).to eq [admin.email, user.email].sort
    end

    it 'includes message subject' do
      expect(subject.subject).to eq message.subject
    end

    it 'has text in body' do
      expect(subject.body)
        .to have_content "A new message has been posted on #{site.name}:"
    end

    it 'has message in body' do
      expect(subject.body).to have_content message.name
      expect(subject.body).to have_content message.email
      expect(subject.body).to have_content message.phone
      expect(subject.body).to have_content message.message
    end
  end
end
