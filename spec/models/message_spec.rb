require 'spec_helper'

describe Message do
  include_context 'new_fields'

  describe 'properties' do
    let(:site) { FactoryGirl.build(:site) }

    subject { Message.new(
      site_id: new_id,
      subject: new_name,
      name: new_name,
      email_address: new_email,
      phone_number: new_phone_number,
      message: new_message,
      site: site,
    )}

    its(:site_id) { should eq new_id }
    its(:subject) { should eq new_name }
    its(:name) { should eq new_name }
    its(:email_address) { should eq new_email }
    its(:phone_number) { should eq new_phone_number }
    its(:message) { should eq new_message }
    its(:site) { should eq site }
  end

  describe 'auto_strip_attributes' do
    before { FactoryGirl.create(:account) }

    subject {
      FactoryGirl.create(:message,
        email_address: "  #{new_email} ",
        message: " #{new_message}  ",
        site: FactoryGirl.create(:site),
      )
    }

    its(:email_address) { should eq new_email }
    its(:message) { should eq " #{new_message}  " }
  end

  describe '#save' do
    before { FactoryGirl.create(:account) }
    let(:site) { FactoryGirl.create(:site) }
    subject { FactoryGirl.build(:message, site: site) }

    it 'saves site_id' do
      subject.save!
      expect(subject.site_id).to eq site.id
    end
  end

  describe 'validate' do
    it { should validate_presence_of(:site_id) }

    it { should validate_presence_of(:subject) }

    it { should validate_presence_of(:name) }

    it { should validate_length_of(:name, maximum: 64) }

    it { should_not allow_values_for(
      :name,
      '<a>bad</a>',
      message: 'HTML not allowed'
    )}

    it { should validate_presence_of(:email_address) }

    it { should validate_length_of(:email_address, maximum: 64) }

    it { should allow_values_for(
      :email_address,
      'someone@example.com',
      'some.one@example.com'
    )}

    it { should_not allow_values_for(
      :email_address,
      'someone',
      '@localhost',
      'someone@',
      message: 'is not a valid email address'
    )}

    it { should_not allow_values_for(
      :email_address,
      '<a>bad</a>',
      message: 'HTML not allowed'
    )}

    it { should validate_length_of(:phone_number, maximum: 32) }

    it { should_not allow_values_for(
      :phone_number,
      '<a>bad</a>',
      message: 'HTML not allowed'
    )}

    it { should validate_presence_of(:message) }

    it { should validate_length_of(:message, maximum: 2048) }

    it { should_not allow_values_for(
      :message,
      '<a>bad</a>',
      message: 'HTML not allowed'
    )}

    it { should_not allow_values_for(
      :message,
      'We can increase rankings of your website in search engines.',
      'How about 100k facebook visitors!',
      'Millions of Facebook page likes',
      'We can get you Facebook likes',
      'Get thousands of facebook followers to your site',
      'superbsocial',
      message: 'Please do not send spam messages.'
    )}

    it { should validate_length_of(
      :do_not_fill_in,
      maximum: 0,
      message: 'do not fill in'
    )}
  end

  describe 'views' do
    before { FactoryGirl.create(:account) }
    let(:site) { FactoryGirl.create(:site) }

    before {
      @message1 = FactoryGirl.create(:message,
        site: site,
        created_at: Time.now - 1.day
      )

      @message2 = FactoryGirl.create(:message,
        site: site,
        created_at: Time.now - 2.days
      )

      @other_message = FactoryGirl.create(
        :message,
        site: FactoryGirl.create(:site)
      )
    }

    describe '.by_site_id_and_created_at' do
      it 'returns messages in order' do
        messages = CouchPotato.database.view(
          Message.by_site_id_and_created_at(
            startkey: [site.id],
            endkey: [site.id, {}]
          )
        )

        expect(messages.size).to eq 2
        expect(messages.first).to eq @message2
        expect(messages.second).to eq @message1
      end
    end

    describe '.by_site_id_and_id' do
      it 'returns messages' do
        expect(CouchPotato.database.view(
          Message.by_site_id_and_id(key: [site.id, @message1.id])
        )).to eq [@message1]
      end
    end

    describe '.find_by_site_and_id' do
      it 'finds a message' do
        expect(Message.find_by_site_and_id(site, @message1.id)).to eq @message1
      end

      it 'returns nil when not found' do
        expect(Message.find_by_site_and_id(site, new_id)).to be_nil
      end

      it 'does not find other sites message' do
        expect(Message.find_by_site_and_id(site, @other_message.id)).to be_nil
      end
    end

    describe '.find_all_by_site' do
      it 'returns messages in reverse order' do
        messages = Message.find_all_by_site(site)
        expect(messages.size).to eq 2
        expect(messages.first).to eq @message1
        expect(messages.second).to eq @message2
      end
    end
  end

  describe 'deliver' do
    before { FactoryGirl.create(:account) }
    let(:site) { FactoryGirl.create(:site) }
    subject { FactoryGirl.create(:message, site: site) }

    it 'sends an email' do
      expect(subject.delivered).to eq false

      expect {
        subject.deliver
      }.to change{ActionMailer::Base.deliveries.size}.by(1)

      expect(subject.delivered).to eq true

      message = ActionMailer::Base.deliveries.last
      expect(message.subject).to eq subject.subject
    end
  end

  describe 'save_spam_message' do
    let(:site) { FactoryGirl.create(:site) }
    subject { FactoryGirl.build(:message, site: site) }

    it 'creates spam message when spam' do
      subject.message = 'facebook followers'

      expect {
        subject.save_spam_message
      }.to change(SpamMessage, :count).by(1)

      spam_message = SpamMessage.all.first
      expect(spam_message.site_id).to eq site.id
      expect(spam_message.name).to eq subject.name
      expect(spam_message.email_address).to eq subject.email_address
      expect(spam_message.phone_number).to eq subject.phone_number
      expect(spam_message.message).to eq 'facebook followers'
    end

    it 'does not create spam message if valid' do
      expect {
        subject.save_spam_message
      }.to_not change(SpamMessage, :count)
    end
  end
end
