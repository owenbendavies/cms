# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  site_id    :integer          not null
#  subject    :string(255)      not null
#  name       :string(64)       not null
#  email      :string(64)       not null
#  phone      :string(32)
#  delivered  :boolean          default("false"), not null
#  message    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Message do
  describe '#site' do
    let(:site) { FactoryGirl.create(:site) }
    subject { FactoryGirl.create(:message, site: site) }

    it 'returns images site' do
      expect(subject.site).to eq site
    end
  end

  it 'is versioned', versioning: true do
    is_expected.to be_versioned
  end

  it 'strips attributes' do
    message = FactoryGirl.create(:message, email: "  #{new_email} ")

    expect(message.email).to eq new_email
  end

  it 'does not strip message' do
    text = " #{new_message}  "

    message = FactoryGirl.create(:message, message: text)

    expect(message.message).to eq text
  end

  describe 'validate' do
    it { should validate_presence_of(:site_id) }

    it { should validate_presence_of(:subject) }

    it { should validate_presence_of(:name) }

    it { should ensure_length_of(:name).is_at_most(64) }

    it do
      should_not allow_value(
        '<a>bad</a>'
      ).for(:name).with_message('HTML not allowed')
    end

    it { should validate_presence_of(:email) }

    it { should ensure_length_of(:email).is_at_most(64) }

    it { should allow_value('someone@example.com').for(:email) }

    it {
      should_not allow_value(
        'someone@'
      ).for(:email).with_message('is not a valid email address')
    }

    it {
      should_not allow_value(
        '<a>bad</a>'
      ).for(:email).with_message('HTML not allowed')
    }

    it { should ensure_length_of(:phone).is_at_most(32) }

    it {
      should_not allow_value(
        '<a>bad</a>'
      ).for(:phone).with_message('HTML not allowed')
    }

    it { should validate_presence_of(:message) }

    it { should ensure_length_of(:message).is_at_most(2048) }

    it {
      should_not allow_value(
        '<a>bad</a>'
      ).for(:message).with_message('HTML not allowed')
    }

    [
      'Get thousands of facebook followers to your site',
      'How about 100k facebook visitors!',
      'Millions of Facebook page likes',
      'We can get you Facebook likes',
      'We can help your website to get on first page of Google',
      'We can increase rankings of your website in search engines.',
      'superbsocial'
    ].each do |message|
      it {
        should_not allow_value(
          message
        ).for(:message).with_message('Please do not send spam messages.')
      }
    end

    it {
      should ensure_length_of(:do_not_fill_in)
        .is_at_most(0)
        .with_message('do not fill in')
    }
  end

  describe 'deliver' do
    subject { FactoryGirl.create(:message) }

    it 'sends an email' do
      expect(subject.delivered).to eq false

      expect {
        subject.deliver
      }.to change {ActionMailer::Base.deliveries.size}.by(1)

      expect(subject.delivered).to eq true

      message = ActionMailer::Base.deliveries.last
      expect(message.subject).to eq subject.subject
    end
  end
end
