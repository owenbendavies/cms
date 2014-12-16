# == Schema Information
#
# Table name: accounts
#
#  id              :integer          not null, primary key
#  email           :string(64)       not null
#  password_digest :string(64)       not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Account do
  it 'has a gravatar_url' do
    account = described_class.new(email: 'test@example.com')
    md5 = '55502f40dc8b7c769880b10874abc9d0'

    expect(account.gravatar_url)
      .to eq "http://gravatar.com/avatar/#{md5}.png?d=mm&r=PG&s=24"
  end

  it { should have_secure_password }

  describe '#sites' do
    subject { FactoryGirl.create(:account) }
    let!(:site1) { FactoryGirl.create(:site, name: 'a') }
    let!(:site2) { FactoryGirl.create(:site, name: 'b') }

    it 'returns sites sorted by site name' do
      subject.sites << site1
      subject.sites << site2

      expect(subject.sites).to eq [site1, site2]
    end
  end

  it 'strips attributes' do
    account = FactoryGirl.create(:account, email: "  #{new_email} ")
    expect(account.email).to eq new_email
  end

  describe 'validate' do
    it { should validate_presence_of(:email) }

    it { should ensure_length_of(:email).is_at_most(64) }

    it { should allow_value('someone@example.com').for(:email) }

    it do
      should_not allow_value(
        'someone@'
      ).for(:email).with_message('is not a valid email address')
    end

    it { should validate_confirmation_of(:password) }

    it { should ensure_length_of(:password).is_at_least(8).is_at_most(64) }

    it { should allow_value('apel203pd0pa').for(:password) }

    it do
      should_not allow_value(
        'password'
      ).for(:password).with_message('is too weak, crack time: instant')
    end
  end

  describe '.find_and_authenticate' do
    let!(:site) { FactoryGirl.create(:site) }
    let!(:account) { site.accounts.first }

    it 'authenticates a valid account' do
      expect(described_class.find_and_authenticate(
        account.email,
        account.password,
        site.host
      )).to eq account
    end

    it 'ignores white space for email' do
      expect(described_class.find_and_authenticate(
        "  #{account.email} ",
        account.password,
        site.host
      )).to eq account
    end

    it 'ignores white space for password' do
      expect(described_class.find_and_authenticate(
        account.email,
        "  #{account.password}  ",
        site.host
      )).to eq account
    end

    it 'ignores case for email' do
      expect(described_class.find_and_authenticate(
        account.email.upcase,
        account.password,
        site.host
      )).to eq account
    end

    it 'returns nil for an invalid email' do
      expect(described_class.find_and_authenticate(
        new_email,
        account.password,
        site.host
      )).to be_nil
    end

    it 'returns nil for a blank email' do
      expect(described_class.find_and_authenticate(
        '',
        account.password,
        site.host
      )).to be_nil
    end

    it 'returns nil for an invalid password' do
      expect(described_class.find_and_authenticate(
        account.email,
        new_password,
        site.host
      )).to be_nil
    end

    it 'returns nil for a blank password' do
      expect(described_class.find_and_authenticate(
        account.email,
        '',
        site.host
      )).to be_nil
    end

    it 'returns nil for invalid site' do
      expect(described_class.find_and_authenticate(
        account.email,
        account.password,
        new_host
      )).to be_nil
    end
  end
end
