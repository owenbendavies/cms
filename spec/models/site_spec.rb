# == Schema Information
#
# Table name: sites
#
#  id                     :integer          not null, primary key
#  host                   :string(64)       not null
#  name                   :string(64)       not null
#  google_analytics       :string(32)
#  charity_number         :string(32)
#  stylesheet_filename    :string(40)
#  sidebar_html_content   :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  main_menu_in_footer    :boolean          default(FALSE), not null
#  separate_header        :boolean          default(TRUE), not null
#  links                  :jsonb
#  privacy_policy_page_id :integer
#  uid                    :string           not null
#
# Indexes
#
#  index_sites_on_host                 (host) UNIQUE
#  index_sites_on_stylesheet_filename  (stylesheet_filename) UNIQUE
#
# Foreign Keys
#
#  fk__sites_privacy_policy_page_id  (privacy_policy_page_id => pages.id)
#

require 'rails_helper'

RSpec.describe Site do
  it_behaves_like 'model with uid'

  describe 'relations' do
    it { is_expected.to have_many(:images).dependent(:destroy) }
    it { is_expected.to have_many(:messages).dependent(:destroy) }
    it { is_expected.to have_many(:pages).dependent(:destroy) }
    it { is_expected.to have_many(:site_settings).dependent(:destroy) }
    it { is_expected.to have_one(:stylesheet).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:site_settings) }
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

    it { is_expected.to validate_uniqueness_of(:stylesheet_filename) }

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
    subject(:site) { FactoryBot.create(:site, host: 'localhost') }

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

  describe '#email' do
    it 'returns noreply email address' do
      site = FactoryBot.build_stubbed(:site, host: 'example.com')
      expect(site.email).to eq 'noreply@example.com'
    end

    it 'returns host without www' do
      site = FactoryBot.build_stubbed(:site, host: 'www.example.com')
      expect(site.email).to eq 'noreply@example.com'
    end
  end
end
