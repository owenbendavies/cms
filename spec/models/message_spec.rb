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
      subject.site_id.should eq site.id
    end
  end

  describe '#create' do
    before { FactoryGirl.create(:account) }
    let(:site) { FactoryGirl.create(:site) }
    subject { FactoryGirl.build(:message, site: site) }

    it 'sends an email' do
      expect {
        subject.save!
      }.to change{ActionMailer::Base.deliveries.size}.by(1)

      message = ActionMailer::Base.deliveries.last
      message.subject.should eq subject.subject
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
      'someone@localhost',
      'someone@localhost.com',
      'some.one@localhost'
    )}

    it { should_not allow_values_for(
      :email_address,
      'someone',
      '@localhost',
      'someone@'
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
      message: 'Please do not send spam messages about SEO.'
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

        messages.size.should eq 2
        messages.first.should eq @message2
        messages.second.should eq @message1
      end
    end

    describe '.by_site_id_and_id' do
      it 'returns messages' do
        CouchPotato.database.view(
          Message.by_site_id_and_id(key: [site.id, @message1.id])
        ).should eq [@message1]
      end
    end

    describe '.find_by_site_and_id' do
      it 'finds a message' do
        Message.find_by_site_and_id(site, @message1.id).should eq @message1
      end

      it 'returns nil when not found' do
        Message.find_by_site_and_id(site, new_id).should be_nil
      end

      it 'does not find other sites message' do
        Message.find_by_site_and_id(site, @other_message.id).should be_nil
      end
    end

    describe '.find_all_by_site' do
      it 'returns messages in reverse order' do
        messages = Message.find_all_by_site(site)
        messages.size.should eq 2
        messages.first.should eq @message1
        messages.second.should eq @message2
      end
    end
  end
end
