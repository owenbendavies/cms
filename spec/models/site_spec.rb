require 'rails_helper'

RSpec.describe Site do
  it_behaves_like 'model with versioning'

  describe 'relations' do
    it { is_expected.to have_many(:images).dependent(:destroy) }
    it { is_expected.to have_many(:messages).dependent(:destroy) }
    it { is_expected.to have_many(:pages).dependent(:destroy) }
    it { is_expected.to belong_to(:privacy_policy_page).class_name('Page').optional }

    context 'with privacy_policy_page' do
      subject(:site) { FactoryBot.create(:site, :with_privacy_policy) }

      it 'can be deleted' do
        site.destroy!
      end
    end
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

  describe 'before validations' do
    it { is_expected.to strip_attribute(:host).collapse_spaces }
    it { is_expected.to strip_attribute(:name).collapse_spaces }
    it { is_expected.to strip_attribute(:charity_number).collapse_spaces }
    it { is_expected.to strip_attribute(:sidebar_html_content) }
    it { is_expected.to strip_attribute(:css) }
  end

  describe 'validations' do
    subject(:site) { FactoryBot.create(:site) }

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
      expect(site).to allow_value(links).for(:links)
    end

    it do
      links = [{ 'name' => 'Site', 'url' => 'http://www.example.com', 'icon' => 'fa-facebook' }]
      expect(site).to allow_value(links).for(:links)
    end

    it do
      links = []
      expect(site).to allow_value(links).for(:links)
    end

    it do
      links = [{ 'name' => 'missing keys' }]
      expect(site).not_to allow_value(links).for(:links).with_message('is not valid')
    end

    it do
      links = [{ 'name' => 'Link', 'url' => 'http://www.tmp.com', 'icon' => nil, 'bad' => 'field' }]
      expect(site).not_to allow_value(links).for(:links).with_message('is not valid')
    end
  end

  describe '#address' do
    subject(:site) { FactoryBot.build(:site) }

    context 'with ssl enabled' do
      it 'returns https url' do
        allow(Rails.configuration.x).to receive(:disable_ssl).and_return(nil)
        expect(site.address).to eq "https://#{site.host}/"
      end
    end

    context 'with ssl disabled' do
      it 'returns http url' do
        expect(site.address).to eq "http://#{site.host}/"
      end
    end
  end

  describe '#url_options' do
    subject(:site) { FactoryBot.build(:site) }

    it 'returns url options' do
      expect(site.url_options).to eq(host: site.host, protocol: 'http', port: nil)
    end

    context 'with ssl enabled' do
      it 'has https protocol' do
        allow(Rails.configuration.x).to receive(:disable_ssl).and_return(nil)
        expect(site.url_options).to eq(host: site.host, protocol: 'https', port: nil)
      end
    end

    context 'with email link port set' do
      it 'has port' do
        allow(Rails.configuration.x).to receive(:email_link_port).and_return('3000')
        expect(site.url_options).to eq(host: site.host, protocol: 'http', port: '3000')
      end
    end
  end
end
