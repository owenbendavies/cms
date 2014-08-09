require 'rails_helper'

RSpec.describe Account do
  include_context 'new_fields'

  it 'has a gravatar_url' do
    account = Account.new(email: 'test@example.com')
    md5 = '55502f40dc8b7c769880b10874abc9d0'

    expect(account.gravatar_url).
      to eq "http://gravatar.com/avatar/#{md5}.png?d=mm&r=PG&s=24"
  end

  it 'has accessors for its properties' do
    account = Account.new(
      email: new_email,
      password: new_password,
      password_confirmation: new_password,
      sites: [new_host],
    )

    expect(account.email).to eq new_email
    expect(account.password).to eq new_password
    expect(account.password_confirmation).to eq new_password
    expect(account.sites).to eq [new_host]
  end

  it 'auto strips attributes' do
    account = FactoryGirl.create(:account, email: "  #{new_email} ")
    expect(account.email).to eq new_email
  end

  describe 'validate' do
    it { should have_secure_password }

    it { should validate_confirmation_of(:password) }

    it { should ensure_length_of(:password).is_at_least(8).is_at_most(64) }

    it { should validate_presence_of(:email) }

    it { should ensure_length_of(:email).is_at_most(64) }

    it {
      should allow_value(
        'someone@example.com',
        'some.one@example.com'
      ).for(:email)
    }

    it {
      should_not allow_value(
        'someone',
        '@localhost',
        'someone@',
      ).for(:email).with_message('is not a valid email address')
    }
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
      expect(subject).to eq [@account]
    end
  end

  describe '.emails_by_site' do
    before { @account = FactoryGirl.create(:account) }

    subject { CouchPotato.database.view(Account.emails_by_site) }

    it 'returns array of emails' do
      expect(subject).to eq [@account.email]
    end
  end

  describe '.find_and_authenticate' do
    let(:site) { FactoryGirl.build(:site) }
    before { @account = FactoryGirl.create(:account) }

    it 'authenticates a valid account' do
      expect(Account.find_and_authenticate(
        @account.email,
        @account.password,
        site.host
      )).to eq @account
    end

    it 'ignores white space for email' do
      expect(Account.find_and_authenticate(
        "  #{@account.email} ",
        @account.password,
        site.host
      )).to eq @account
    end

    it 'ignores white space for password' do
      expect(Account.find_and_authenticate(
        @account.email,
        "  #{@account.password}  ",
        site.host
      )).to eq @account
    end

    it 'ignores case for email' do
      expect(Account.find_and_authenticate(
        @account.email.upcase,
        @account.password,
        site.host
      )).to eq @account
    end

    it 'returns nil for an invalid email' do
      expect(Account.find_and_authenticate(
        new_email,
        @account.password,
        site.host
      )).to be_nil
    end

    it 'returns nil for a blank email' do
      expect(Account.find_and_authenticate(
        '',
        @account.password,
        site.host
      )).to be_nil
    end

    it 'returns nil for an invalid password' do
      expect(Account.find_and_authenticate(
        @account.email,
        new_password,
        site.host
      )).to be_nil
    end

    it 'returns nil for a blank password' do
      expect(Account.find_and_authenticate(
        @account.email,
        '',
        site.host
      )).to be_nil
    end

    it 'returnss nil for invalid site' do
      expect(Account.find_and_authenticate(
        @account.email,
        @account.password,
        new_host
      )).to be_nil
    end
  end

  describe '.find_emails_by_site' do
    before do
      @site = FactoryGirl.create(:site)
      @account = FactoryGirl.create(:account)
      @another_account = FactoryGirl.create(:account)
    end

    it 'returns all emails' do
      expect(Account.find_emails_by_site(@site)).to eq(
        [@account.email, @another_account.email].sort
      )
    end
  end
end
