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
#  facebook             :string(64)
#  twitter              :string(15)
#  linkedin             :string(32)
#  github               :string(32)
#  youtube              :string(32)
#
# Indexes
#
#  index_sites_on_host  (host) UNIQUE
#

require 'rails_helper'

RSpec.describe Site, type: :model do
  it { should have_many(:images).order(:name).dependent(:destroy) }
  it { should have_many(:messages).order('created_at desc').dependent(:destroy) }
  it { should have_many(:pages).order(:name).dependent(:destroy) }
  it { should have_many(:site_settings).dependent(:destroy) }
  it { should have_many(:users) }
  it { should have_many(:main_menu_pages) }

  describe '#main_menu_pages' do
    subject { FactoryGirl.create(:site) }

    it 'returns empty array when no pages' do
      expect(subject.main_menu_pages).to eq []
    end

    it 'returns pages when page ids' do
      page1 = FactoryGirl.create(:page, site: subject)
      page1.insert_at(1)
      page2 = FactoryGirl.create(:page, site: subject)
      page2.insert_at(1)

      FactoryGirl.create(:page, site: subject)

      expect(subject.main_menu_pages).to eq [page2, page1]
    end
  end

  describe '#stylesheet' do
    it 'has a stylesheet' do
      css = "body {\r\n  padding: 4em;\r\n}"
      file = StringUploader.new('stylesheet.css', css)
      site = FactoryGirl.create(:site, stylesheet: file)

      expect(site.stylesheet_filename).to match(/\A[0-9a-f-]+\.css/)

      expect(site.stylesheet.url).to eq File.join(
        'https://obduk-cms-test.s3-eu-west-1.amazonaws.com',
        site.id.to_s,
        site.stylesheet_filename
      )

      expect(uploaded_files).to eq ["#{site.id}/#{site.stylesheet_filename}"]
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
      should validate_presence_of(:name)
    end

    it { should validate_length_of(:name).is_at_least(3).is_at_most(64) }

    it { should validate_length_of(:sub_title).is_at_least(3).is_at_most(64) }

    it { should allow_value('one_column').for(:layout) }

    it { should allow_value('').for(:google_analytics) }
    it { should allow_value('UA-1234-1').for(:google_analytics) }
    it { should allow_value('UA-123456-1').for(:google_analytics) }
    it { should allow_value('UA-123456-22').for(:google_analytics) }

    it { should_not allow_value('XA-1234-1').for(:google_analytics) }
    it { should_not allow_value('UA-1234').for(:google_analytics) }
    it { should_not allow_value('UA123').for(:google_analytics) }
    it { should_not allow_value('AS').for(:google_analytics) }
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
      expect(uploaded_files).to eq []

      subject.css = "body {\r\n  padding: 4em;\r\n}"
      subject.save!
      subject.stylesheet.file.send(:file).reload

      expect(uploaded_files).to eq ["#{subject.id}/#{subject.stylesheet_filename}"]
    end

    it 'deletes old version' do
      expect(uploaded_files).to eq []

      subject.css = "body {\r\n  padding: 4em;\r\n}"
      subject.save!

      expect(uploaded_files).to eq ["#{subject.id}/#{subject.stylesheet_filename}"]

      site = described_class.find_by_id(subject.id)
      site.css = 'body{background-color: red}'
      site.save!

      expect(uploaded_files).to eq ["#{site.id}/#{site.stylesheet_filename}"]
      expect(site.stylesheet_filename).not_to eq subject.stylesheet_filename
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

  describe '#store_dir' do
    subject { FactoryGirl.create(:site) }

    it 'is site id' do
      expect(subject.store_dir).to eq subject.id.to_s
    end
  end

  describe '#social_networks?' do
    subject { described_class.new }

    it 'returns true with facebook' do
      subject.facebook = new_facebook
      expect(subject.social_networks?).to eq true
    end

    it 'returns true with twitter' do
      subject.twitter = new_twitter
      expect(subject.social_networks?).to eq true
    end

    it 'returns true with youtube' do
      subject.youtube = new_youtube
      expect(subject.social_networks?).to eq true
    end

    it 'returns true with linkedin' do
      subject.linkedin = new_linkedin
      expect(subject.social_networks?).to eq true
    end

    it 'returns true with github' do
      subject.github = new_github
      expect(subject.social_networks?).to eq true
    end

    it 'returns false with no social networks' do
      expect(subject.social_networks?).to eq false
    end
  end
end
