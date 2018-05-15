# == Schema Information
#
# Table name: sites
#
#  id                     :integer          not null, primary key
#  host                   :string(64)       not null
#  name                   :string(64)       not null
#  sub_title              :string(64)
#  copyright              :string(64)
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
  describe '#stylesheet' do
    let(:css) { "body {\r\n  padding: 4em;\r\n}" }
    let(:file) { StringUploader.new('stylesheet.css', css) }
    let!(:site) { FactoryBot.create(:site, stylesheet: file) }
    let(:uuid) { File.basename(site.stylesheet_filename, '.css') }

    it 'saves the stylesheet' do
      expect(uploaded_files).to eq ["stylesheets/#{uuid}/original.css"]
    end

    it 'uses a uuid as the filename' do
      expect(site.stylesheet_filename).to match(/\A[0-9a-f-]+\.css/)
    end

    it 'is saved in the stylesheets directory on s3' do
      expect(site.stylesheet.public_url).to eq File.join(
        'http://localhost:37511', 'stylesheets', uuid, 'original.css'
      )
    end
  end

  describe 'relations' do
    it { is_expected.to have_many(:images).dependent(:destroy) }
    it { is_expected.to have_many(:messages).dependent(:destroy) }
    it { is_expected.to have_many(:pages).dependent(:destroy) }
    it { is_expected.to have_many(:site_settings).dependent(:destroy) }
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
    it { is_expected.to strip_attribute(:sub_title).collapse_spaces }
    it { is_expected.to strip_attribute(:copyright).collapse_spaces }
    it { is_expected.to strip_attribute(:charity_number).collapse_spaces }
    it { is_expected.not_to strip_attribute(:sidebar_html_content).collapse_spaces }
  end

  describe 'validations' do
    subject { FactoryBot.build(:site) }

    it { is_expected.to validate_length_of(:host).is_at_most(64) }
    it { is_expected.to validate_presence_of(:host) }
    it { is_expected.to validate_uniqueness_of(:host) }

    it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(64) }
    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_length_of(:sub_title).is_at_least(3).is_at_most(64) }

    it { is_expected.to validate_length_of(:copyright).is_at_most(64) }

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

  describe '#css' do
    subject(:site) { FactoryBot.build(:site) }

    it 'returns returns css' do
      site.css = "body {\r\n  padding: 4em;\r\n}"
      site.save!
      site.stylesheet.file.send(:file).reload
      expect(site.css).to eq "body {\r\n  padding: 4em;\r\n}"
    end

    it 'returns nil when empty' do
      expect(site.css).to be_nil
    end
  end

  describe '#css=' do
    subject(:site) { FactoryBot.build(:site) }

    it 'strips end of line whitespace' do
      site.css = "body {\r\n  padding: 4em; \r\n}"
      expect(site.css).to eq "body {\r\n  padding: 4em;\r\n}"
    end

    it 'converts tabs to spaces' do
      site.css = "body {\r\n\tpadding: 4em;\r\n}"
      expect(site.css).to eq "body {\r\n  padding: 4em;\r\n}"
    end

    it 'saves a file' do
      site.css = "body {\r\n  padding: 4em;\r\n}"
      site.save!
      site.stylesheet.file.send(:file).reload

      uuid = File.basename(site.stylesheet_filename, '.css')
      expect(uploaded_files).to eq ["stylesheets/#{uuid}/original.css"]
    end

    context 'with an exiting file' do
      let(:another_site) { described_class.find_by(id: site.id) }
      let(:uuid) { File.basename(another_site.stylesheet_filename, '.css') }

      before do
        site.css = "body {\r\n  padding: 4em;\r\n}"
        site.save!
        another_site.css = 'body{background-color: red}'
        another_site.save!
      end

      it 'deletes old version' do
        expect(uploaded_files).to eq ["stylesheets/#{uuid}/original.css"]
      end

      it 'creates new filename' do
        expect(another_site.stylesheet_filename).not_to eq site.stylesheet_filename
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
