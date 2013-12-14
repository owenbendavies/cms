require 'spec_helper'

describe Account do
  include_context 'new_fields'

  describe 'properties' do
    subject {
      Account.new(
        email: new_email,
        password: new_password,
        password_confirmation: new_password,
        sites: [new_host],
      )
    }

    its(:gravatar_url) {
      md5 = Digest::MD5.hexdigest(new_email)
      should eq  "http://gravatar.com/avatar/#{md5}.png?d=mm&r=PG&s=24"
    }

    its(:email) { should eq new_email }
    its(:sites) { should eq [new_host] }
    its(:password) { should eq new_password }
    its(:password_confirmation) { should eq new_password }
  end

  describe 'auto_strip_attributes' do
    subject { FactoryGirl.create(:account, email: "  #{new_email} ") }

    its(:email) { should eq new_email }
  end

  describe 'validate' do
    it { should validate_length_of(
      :password,
      minimum: 8,
      maximum: 64,
      allow_blank: true)
    }

    it { should validate_presence_of(:email) }

    it { should validate_length_of(:email, maximum: 64) }

    it { should allow_values_for(
      :email,
      'someone@localhost',
      'someone@localhost.com',
      'some.one@localhost'
    )}

    it { should_not allow_values_for(
      :email,
      'someone',
      '@localhost',
      'someone@'
    )}
  end

  describe '.by_site_host_and_email' do
    let(:site) { FactoryGirl.create(:site) }
    before { @account = FactoryGirl.create(:account) }

    subject {
      CouchPotato.database.view(
        Account.by_site_host_and_email(key: [site.host, @account.email])
      )
    }

    it 'returns the account' do
      subject.should eq [@account]
    end
  end

  describe '.emails_by_site' do
    before { @account = FactoryGirl.create(:account) }

    subject { CouchPotato.database.view(Account.emails_by_site) }

    it 'returns array of emails' do
      subject.should eq [@account.email]
    end
  end

  describe '.find_and_authenticate' do
    let(:site) { FactoryGirl.build(:site) }
    before { @account = FactoryGirl.create(:account) }

    it 'authenticates a valid account' do
      Account.find_and_authenticate(
        @account.email,
        @account.password,
        site.host
      ).should eq @account
    end

    it 'ignores white space for email' do
      Account.find_and_authenticate(
        "  #{@account.email} ",
        @account.password,
        site.host
      ).should eq @account
    end

    it 'ignores white space for password' do
      Account.find_and_authenticate(
        @account.email,
        "  #{@account.password}  ",
        site.host
      ).should eq @account
    end

    it 'ignores case for email' do
      Account.find_and_authenticate(
        @account.email.upcase,
        @account.password,
        site.host
      ).should eq @account
    end

    it 'returns nil for an invalid email' do
      Account.find_and_authenticate(
        new_email,
        @account.password,
        site.host
      ).should be_nil
    end

    it 'returns nil for a blank email' do
      Account.find_and_authenticate(
        '',
        @account.password,
        site.host
      ).should be_nil
    end

    it 'returns nil for an invalid password' do
      Account.find_and_authenticate(
        @account.email,
        new_password,
        site.host
      ).should be_nil
    end

    it 'returns nil for a blank password' do
      Account.find_and_authenticate(
        @account.email,
        '',
        site.host
      ).should be_nil
    end

    it 'returnss nil for invalid site' do
      Account.find_and_authenticate(
        @account.email,
        @account.password,
        new_host
      ).should be_nil
    end
  end

  describe '.find_emails_by_site' do
    before do
      @site = FactoryGirl.create(:site)
      @account = FactoryGirl.create(:account)
      @another_account = FactoryGirl.create(:account)
    end

    it 'returns all emails' do
      Account.find_emails_by_site(@site).should eq(
        [@account.email, @another_account.email].sort
      )
    end
  end
end
