require 'spec_helper'

describe MessageMailer do
  include_context 'new_fields'

  describe '.new_message' do
    let(:site) { FactoryGirl.build(:site) }
    let(:message) { FactoryGirl.build(:message, site: site) }

    before do
      @account = FactoryGirl.create(:account)

      expect {
        MessageMailer.new_message(message).deliver
      }.to change{ActionMailer::Base.deliveries.size}.by(1)
    end

    subject { ActionMailer::Base.deliveries.last }

    it 'should have from address of site' do
      subject.header["From"].to_s.gsub('"', '').
        should eq "#{site.name} <noreply@#{site.host}>"
    end

    its(:to) { should eq [@account.email] }
    its(:subject) { should eq message.subject }
    its(:body) { should include "Name: #{message.name}" }
    its(:body) { should include "Email address: #{message.email_address}" }
    its(:body) { should include "Phone number: #{message.phone_number}" }
    its(:body) { should include "Message: #{message.message}" }
  end

  describe 'site with www host' do
    let(:site) { FactoryGirl.build(:site, host: 'www.example.com') }
    let(:message) { FactoryGirl.build(:message, site: site) }

    before do
      @account = FactoryGirl.create(:account, sites: ['www.example.com'])

      expect {
        MessageMailer.new_message(message).deliver
      }.to change{ActionMailer::Base.deliveries.size}.by(1)
    end

    subject { ActionMailer::Base.deliveries.last }

    it 'should remove www from email' do
      subject.header["From"].to_s.gsub('"', '').
        should eq "#{site.name} <noreply@example.com>"
    end
  end
end
