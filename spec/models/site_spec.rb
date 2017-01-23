# == Schema Information
#
# Table name: sites
#
#  id                   :integer          not null, primary key
#  host                 :string(64)       not null
#  name                 :string(64)       not null
#  sub_title            :string(64)
#  layout               :string(32)       default("one_column"), not null
#  copyright            :string(64)
#  google_analytics     :string(32)
#  charity_number       :string(32)
#  stylesheet_filename  :string(40)
#  sidebar_html_content :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  main_menu_in_footer  :boolean          default(FALSE), not null
#  separate_header      :boolean          default(TRUE), not null
#
# Indexes
#
#  index_sites_on_host                 (host) UNIQUE
#  index_sites_on_stylesheet_filename  (stylesheet_filename) UNIQUE
#

require 'rails_helper'

RSpec.describe Site do
  describe '#main_menu_pages' do
    subject { FactoryGirl.create(:site) }

    context 'when no pages' do
      it 'returns empty array' do
        expect(subject.main_menu_pages).to eq []
      end
    end

    context 'with pages' do
      let!(:page1) do
        FactoryGirl.create(:page, site: subject).tap do |page|
          page.insert_at(1)
        end
      end

      let!(:page2) do
        FactoryGirl.create(:page, site: subject).tap do |page|
          page.insert_at(1)
        end
      end

      let!(:other_page) { FactoryGirl.create(:page, site: subject) }

      it 'returns pages when page ids' do
        expect(subject.main_menu_pages).to eq [page2, page1]
      end
    end
  end

  describe '#footer_links' do
    subject { FactoryGirl.create(:site) }

    context 'when no links' do
      it 'returns empty array' do
        expect(subject.footer_links).to eq []
      end
    end

    context 'with footer links' do
      let!(:link1) { FactoryGirl.create(:footer_link, site: subject) }
      let!(:link2) { FactoryGirl.create(:footer_link, site: subject) }
      let!(:other_link) { FactoryGirl.create(:footer_link) }

      it 'returns links in order' do
        expect(subject.footer_links).to eq [link1, link2]
      end
    end
  end

  describe '#stylesheet' do
    let(:css) { "body {\r\n  padding: 4em;\r\n}" }
    let(:file) { StringUploader.new('stylesheet.css', css) }
    let!(:site) { FactoryGirl.create(:site, stylesheet: file) }
    let(:uuid) { File.basename(site.stylesheet_filename, '.css') }

    it 'saves the stylesheet' do
      expect(uploaded_files).to eq ["stylesheets/#{uuid}/original.css"]
    end

    it 'uses a uuid as the filename' do
      expect(site.stylesheet_filename).to match(/\A[0-9a-f-]+\.css/)
    end

    it 'is saved in the stylesheets directory on s3' do
      expect(site.stylesheet.url).to eq File.join(
        'https://obduk-cms-test.s3-eu-east-1.amazonaws.com', 'stylesheets', uuid, 'original.css'
      )
    end
  end

  describe '.ordered' do
    it 'returns ordered by host' do
      site_c = FactoryGirl.create(:site, host: 'sitec')
      site_a = FactoryGirl.create(:site, host: 'sitea')
      site_b = FactoryGirl.create(:site, host: 'siteb')

      expect(described_class.ordered).to eq [site_a, site_b, site_c]
    end
  end

  it { is_expected.to strip_attribute(:host).collapse_spaces }
  it { is_expected.to strip_attribute(:name).collapse_spaces }
  it { is_expected.to strip_attribute(:sub_title).collapse_spaces }
  it { is_expected.to strip_attribute(:copyright).collapse_spaces }
  it { is_expected.to strip_attribute(:charity_number).collapse_spaces }
  it { is_expected.not_to strip_attribute(:sidebar_html_content).collapse_spaces }

  describe '#valid?' do
    it 'validates database schema' do
      is_expected.to validate_presence_of(:name)
    end

    it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(64) }

    it { is_expected.to validate_length_of(:sub_title).is_at_least(3).is_at_most(64) }

    it { is_expected.to allow_value('one_column').for(:layout) }

    it { is_expected.to allow_value('').for(:google_analytics) }
    it { is_expected.to allow_value('UA-1234-1').for(:google_analytics) }
    it { is_expected.to allow_value('UA-123456-1').for(:google_analytics) }
    it { is_expected.to allow_value('UA-123456-22').for(:google_analytics) }

    it { is_expected.not_to allow_value('XA-1234-1').for(:google_analytics) }
    it { is_expected.not_to allow_value('UA-1234').for(:google_analytics) }
    it { is_expected.not_to allow_value('UA123').for(:google_analytics) }
    it { is_expected.not_to allow_value('AS').for(:google_analytics) }
  end

  describe '#address' do
    subject { FactoryGirl.create(:site, host: 'localhost') }

    context 'when ssl is enabled' do
      around do |example|
        ClimateControl.modify(DISABLE_SSL: nil) do
          example.run
        end
      end

      it 'returns https url' do
        expect(subject.address).to eq 'https://localhost'
      end
    end

    context 'when ssl is disabled' do
      it 'returns http url' do
        expect(subject.address).to eq 'http://localhost'
      end
    end
  end

  describe '#css' do
    subject { FactoryGirl.build(:site) }

    it 'returns returns css' do
      subject.css = "body {\r\n  padding: 4em;\r\n}"
      subject.save!
      subject.stylesheet.file.send(:file).reload
      expect(subject.css).to eq "body {\r\n  padding: 4em;\r\n}"
    end

    it 'returns nil when empty' do
      expect(subject.css).to be_nil
    end
  end

  describe '#css=' do
    subject { FactoryGirl.build(:site) }

    it 'strips end of line whitespace' do
      subject.css = "body {\r\n  padding: 4em; \r\n}"
      expect(subject.css).to eq "body {\r\n  padding: 4em;\r\n}"
    end

    it 'converts tabs to spaces' do
      subject.css = "body {\r\n\tpadding: 4em;\r\n}"
      expect(subject.css).to eq "body {\r\n  padding: 4em;\r\n}"
    end

    it 'saves a file' do
      subject.css = "body {\r\n  padding: 4em;\r\n}"
      subject.save!
      subject.stylesheet.file.send(:file).reload

      uuid = File.basename(subject.stylesheet_filename, '.css')
      expect(uploaded_files).to eq ["stylesheets/#{uuid}/original.css"]
    end

    context 'with an exiting file' do
      let(:site) { described_class.find_by(id: subject.id) }
      let(:uuid) { File.basename(site.stylesheet_filename, '.css') }

      before do
        subject.css = "body {\r\n  padding: 4em;\r\n}"
        subject.save!
      end

      it 'deletes old version' do
        site.css = 'body{background-color: red}'
        site.save!

        expect(uploaded_files).to eq ["stylesheets/#{uuid}/original.css"]
        expect(site.stylesheet_filename).not_to eq subject.stylesheet_filename
      end
    end
  end

  describe '#email' do
    it 'returns noreply email address' do
      site = FactoryGirl.create(:site, host: 'example.com')
      expect(site.email).to eq 'noreply@example.com'
    end

    it 'returns host without www' do
      site = FactoryGirl.create(:site, host: 'www.example.com')
      expect(site.email).to eq 'noreply@example.com'
    end
  end
end
