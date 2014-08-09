require 'rails_helper'

describe Message do
  include_context 'new_fields'

  it 'has accessors for its properties' do
    site = FactoryGirl.build(:site)

    message = Message.new(
      subject: new_name,
      name: new_name,
      email_address: new_email,
      phone_number: new_phone_number,
      message: new_message,
      site: site,
    )

    expect(message.subject).to eq new_name
    expect(message.name).to eq new_name
    expect(message.email_address).to eq new_email
    expect(message.phone_number).to eq new_phone_number
    expect(message.site).to eq site
  end

  it 'auto strips attributes' do
    message = FactoryGirl.create(
      :message,
      email_address: "  #{new_email} ",
    )

    expect(message.email_address).to eq new_email
  end

  it 'does not auto strip message' do
    text = " #{new_message}  "

    message = FactoryGirl.create(
      :message,
      message: text,
    )

    expect(message.message).to eq text
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

    it { should ensure_length_of(:name).is_at_most(64) }

    it {
      should_not allow_value(
        '<a>bad</a>'
      ).for(:name).with_message('HTML not allowed')
    }

    it { should validate_presence_of(:email_address) }

    it { should ensure_length_of(:email_address).is_at_most(64) }

    it {
      should allow_value(
        'someone@example.com',
        'some.one@example.com'
      ).for(:email_address)
    }

    it {
      should_not allow_value(
        'someone',
        '@localhost',
        'someone@',
      ).for(:email_address).with_message('is not a valid email address')
    }

    it {
      should_not allow_value(
        '<a>bad</a>'
      ).for(:email_address).with_message('HTML not allowed')
    }

    it { should ensure_length_of(:phone_number).is_at_most(32) }

    it {
      should_not allow_value(
        '<a>bad</a>'
      ).for(:phone_number).with_message('HTML not allowed')
    }

    it { should validate_presence_of(:message) }

    it { should ensure_length_of(:message).is_at_most(2048) }

    it {
      should_not allow_value(
        '<a>bad</a>'
      ).for(:message).with_message('HTML not allowed')
    }

    it {
      should_not allow_value(
        'We can increase rankings of your website in search engines.',
        'How about 100k facebook visitors!',
        'Millions of Facebook page likes',
        'We can get you Facebook likes',
        'Get thousands of facebook followers to your site',
        'superbsocial'
      ).for(:message).with_message('Please do not send spam messages.')
    }

    it {
      should ensure_length_of(:do_not_fill_in).
               is_at_most(0).
               with_message('do not fill in')
    }
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
      subject.do_not_fill_in = new_name

      expect {
        subject.save_spam_message
      }.to change(SpamMessage, :count).by(1)

      spam_message = SpamMessage.all.first
      expect(spam_message.site_id).to eq site.id
      expect(spam_message.name).to eq subject.name
      expect(spam_message.email_address).to eq subject.email_address
      expect(spam_message.phone_number).to eq subject.phone_number
      expect(spam_message.message).to eq subject.message
      expect(spam_message.do_not_fill_in).to eq new_name
    end

    it 'does not create spam message if valid' do
      expect {
        subject.save_spam_message
      }.to_not change(SpamMessage, :count)
    end
  end
end
