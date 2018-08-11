require 'rails_helper'

RSpec.describe Site do
  it_behaves_like 'model with uid'
  it_behaves_like 'model with versioning'

  describe 'callbacks' do
    describe 'after save' do
      let(:site) { FactoryBot.build(:site) }

      it 'updates cognito sites' do
        expect { site.save! }.to have_enqueued_job(UpdateCognitoSitesJob)
      end
    end

    describe 'after destroy' do
      let!(:site) { FactoryBot.create(:site) }

      it 'updates cognito sites' do
        expect { site.destroy! }.to have_enqueued_job(UpdateCognitoSitesJob)
      end
    end
  end

  describe 'default values' do
    subject(:site) { described_class.new }

    let(:environment_variables) do
      {
        'SEED_SITE_EMAIL' => new_email
      }
    end

    it 'sets email as SEED_SITE_EMAIL' do
      expect(site.email).to eq new_email
    end
  end

  describe 'relations' do
    it { is_expected.to have_many(:images).dependent(:destroy) }
    it { is_expected.to have_many(:messages).dependent(:destroy) }
    it { is_expected.to have_many(:pages).dependent(:destroy) }
    it { is_expected.to have_one(:stylesheet).dependent(:destroy) }
    it { is_expected.to belong_to(:privacy_policy_page) }
  end

  describe '#main_menu_pages' do
    subject(:site) { FactoryBot.create(:site) }

    context 'without pages' do
      it 'returns empty array' do
        expect(site.main_menu_pages).to be_empty
      end
    end

    context 'with pages' do
      let!(:page1) do
        FactoryBot.create(:page, site: site).tap do |page|
          page.insert_at(1)
        end
      end

      let!(:page2) do
        FactoryBot.create(:page, site: site).tap do |page|
          page.insert_at(1)
        end
      end

      before { FactoryBot.create(:page, site: site) }

      it 'returns pages when page ids' do
        expect(site.main_menu_pages).to eq [page2, page1]
      end
    end
  end

  describe 'scopes' do
    describe '.ordered' do
      it 'returns ordered by host' do
        site_c = FactoryBot.create(:site, host: 'sitec')
        site_a = FactoryBot.create(:site, host: 'sitea')
        site_b = FactoryBot.create(:site, host: 'siteb')

        expect(described_class.ordered).to eq [site_a, site_b, site_c]
      end
    end
  end

  describe 'before validations' do
    it { is_expected.to strip_attribute(:host).collapse_spaces }
    it { is_expected.to strip_attribute(:name).collapse_spaces }
    it { is_expected.to strip_attribute(:charity_number).collapse_spaces }
    it { is_expected.not_to strip_attribute(:sidebar_html_content).collapse_spaces }
  end

  describe 'validations' do
    subject { FactoryBot.create(:site) }

    it { is_expected.to validate_length_of(:host).is_at_most(64) }
    it { is_expected.to validate_presence_of(:host) }
    it { is_expected.to validate_uniqueness_of(:host) }

    it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(64) }
    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to allow_value('').for(:google_analytics) }
    it { is_expected.to allow_value('UA-1234-1').for(:google_analytics) }
    it { is_expected.to allow_value('UA-123456-1').for(:google_analytics) }
    it { is_expected.to allow_value('UA-123456-22').for(:google_analytics) }
    it { is_expected.not_to allow_value('XA-1234-1').for(:google_analytics) }
    it { is_expected.not_to allow_value('UA-1234').for(:google_analytics) }
    it { is_expected.not_to allow_value('UA123').for(:google_analytics) }
    it { is_expected.not_to allow_value('AS').for(:google_analytics) }

    it { is_expected.to validate_length_of(:charity_number).is_at_most(32) }

    it do
      links = [{ 'name' => 'Site', 'url' => 'http://www.example.com', 'icon' => nil }]
      is_expected.to allow_value(links).for(:links)
    end

    it do
      links = [{ 'name' => 'Site', 'url' => 'http://www.example.com', 'icon' => 'fa-facebook' }]
      is_expected.to allow_value(links).for(:links)
    end

    it do
      links = []
      is_expected.to allow_value(links).for(:links)
    end

    it do
      links = [{ 'name' => 'missing keys' }]
      is_expected.not_to allow_value(links).for(:links).with_message('is not valid')
    end

    it do
      links = [{ 'name' => 'Link', 'url' => 'http://www.tmp.com', 'icon' => nil, 'bad' => 'field' }]
      is_expected.not_to allow_value(links).for(:links).with_message('is not valid')
    end
  end

  describe '#address' do
    subject(:site) { FactoryBot.build(:site, host: 'localhost') }

    context 'with ssl enabled' do
      let(:environment_variables) { { DISABLE_SSL: nil } }

      it 'returns https url' do
        expect(site.address).to eq 'https://localhost'
      end
    end

    context 'with ssl disabled' do
      it 'returns http url' do
        expect(site.address).to eq 'http://localhost'
      end
    end
  end

  describe '#url_options' do
    subject(:site) { FactoryBot.build(:site, host: 'localhost') }

    it 'has host' do
      expect(site.url_options.fetch(:host)).to eq 'localhost'
    end

    context 'with ssl enabled' do
      let(:environment_variables) { { DISABLE_SSL: nil } }

      it 'has https protocl' do
        expect(site.url_options.fetch(:protocol)).to eq 'https'
      end
    end

    context 'with ssl disabled' do
      let(:environment_variables) { { DISABLE_SSL: 'true' } }

      it 'has http protocal' do
        expect(site.url_options.fetch(:protocol)).to eq 'http'
      end
    end

    context 'with email link port set' do
      let(:environment_variables) { { EMAIL_LINK_PORT: '37511' } }

      it 'has port' do
        expect(site.url_options.fetch(:port)).to eq '37511'
      end
    end

    context 'with email link port not set' do
      let(:environment_variables) { { EMAIL_LINK_PORT: nil } }

      it 'has no port' do
        expect(site.url_options.fetch(:port)).to eq nil
      end
    end
  end

  describe '#user_emails' do
    subject(:site) { FactoryBot.build(:site) }

    let(:user_emails) { ['siteuser@example.com', 'sysadmin@example.com', 'admin@example.com'] }

    it 'returns email addresses of users in site from AWS' do
      expect(site.user_emails).to eq user_emails
    end
  end
end
