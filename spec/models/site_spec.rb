# == Schema Information
#
# Table name: sites
#
#  id                   :integer          not null, primary key
#  host                 :string(64)       not null
#  name                 :string(64)       not null
#  sub_title            :string(64)
#  layout               :string(32)       default("one_column")
#  main_menu_page_ids   :text
#  copyright            :string(64)
#  google_analytics     :string(32)
#  charity_number       :string(32)
#  stylesheet_filename  :string(36)
#  logo_filename        :string(36)
#  sidebar_html_content :text
#  created_by_id        :integer          not null
#  updated_by_id        :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  main_menu_in_footer  :boolean          default(FALSE), not null
#  separate_header      :boolean          default(TRUE), not null
#  facebook             :string(32)
#  twitter              :string(15)
#  linkedin             :string(32)
#  github               :string(32)
#

require 'rails_helper'

RSpec.describe Site do
  it { should belong_to(:created_by).class_name('User') }
  it { should belong_to(:updated_by).class_name('User') }
  it { should have_and_belong_to_many(:users) }
  it { should have_many(:images).order(:name).dependent(:destroy) }

  it do
    should have_many(:messages).order('created_at desc').dependent(:destroy)
  end

  it { should have_many(:pages).order(:name).dependent(:destroy) }

  it 'is versioned', versioning: true do
    is_expected.to be_versioned
  end

  describe '#stylesheet', uploads: true do
    it 'has a stylesheet' do
      site = FactoryGirl.build(:site)
      stylesheet = site.stylesheet

      expect(stylesheet.url).to eq File.join(
        '/',
        Rails.application.secrets.uploads_store_dir,
        site.id.to_s,
        site.stylesheet_filename
      )
    end
  end

  describe '#logo', uploads: true do
    it 'saves an image' do
      site = FactoryGirl.create(
        :site,
        logo: File.open(Rails.root.join('spec/assets/test_image.jpg'))
      )

      expect(site.logo.url).to eq File.join(
        '/',
        Rails.application.secrets.uploads_store_dir,
        site.id.to_s,
        site.logo_filename
      )

      expect(uploaded_files)
        .to include "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb.jpg"
    end
  end

  it { is_expected.to strip_attribute(:host).collapse_spaces }
  it { is_expected.to strip_attribute(:name).collapse_spaces }
  it { is_expected.to strip_attribute(:sub_title).collapse_spaces }
  it { is_expected.to strip_attribute(:copyright).collapse_spaces }
  it { is_expected.to strip_attribute(:charity_number).collapse_spaces }

  it do
    is_expected.to_not strip_attribute(:sidebar_html_content).collapse_spaces
  end

  describe 'validate' do
    subject { FactoryGirl.build(:site) }

    it { should validate_presence_of(:host) }

    it { should validate_uniqueness_of(:host) }

    it { should validate_presence_of(:name) }

    it { should validate_length_of(:name).is_at_most(64) }

    it { should validate_length_of(:sub_title).is_at_most(64) }

    it { should allow_value('one_column').for(:layout) }
    it { should allow_value('right_sidebar').for(:layout) }
    it { should allow_value('small_right_sidebar').for(:layout) }

    it { should validate_length_of(:copyright).is_at_most(64) }

    it { should allow_value('').for(:google_analytics) }
    it { should allow_value('UA-1234-1').for(:google_analytics) }
    it { should allow_value('UA-123456-1').for(:google_analytics) }
    it { should allow_value('UA-123456-22').for(:google_analytics) }

    it { should_not allow_value('XA-1234-1').for(:google_analytics) }
    it { should_not allow_value('UA-1234').for(:google_analytics) }
    it { should_not allow_value('UA123').for(:google_analytics) }
    it { should_not allow_value('AS').for(:google_analytics) }

    it { should validate_presence_of(:updated_by) }

    it { should validate_length_of(:facebook).is_at_most(32) }

    it { should validate_length_of(:twitter).is_at_most(15) }

    it { should validate_length_of(:linkedin).is_at_most(32) }

    it { should validate_length_of(:github).is_at_most(32) }
  end

  describe '#css', uploads: true do
    subject { FactoryGirl.build(:site, stylesheet_filename: nil) }

    context 'with css' do
      before do
        subject.css = "body {\r\n  padding: 4em;\r\n}"
        subject.save!
      end

      it 'returns css' do
        expect(subject.css).to eq "body {\r\n  padding: 4em;\r\n}"
      end
    end

    context 'when empty' do
      it 'returns nil' do
        expect(subject.css).to be_nil
      end
    end
  end

  describe '#css=', uploads: true do
    subject { FactoryGirl.build(:site, stylesheet_filename: nil) }

    it 'strips end of line whitespace' do
      subject.css = "body {\r\n  padding: 4em; \r\n}"
      subject.save!
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

      expect(subject.stylesheet_filename)
        .to eq 'e6df26f541ebad8e8fed26a84e202a7c.css'

      expect(uploaded_files).to eq [
        "#{subject.id}",
        "#{subject.id}/e6df26f541ebad8e8fed26a84e202a7c.css"
      ]
    end

    it 'deletes old version' do
      expect(uploaded_files).to eq []

      subject.css = "body {\r\n  padding: 4em;\r\n}"
      subject.save!
      expect(subject.css).to eq "body {\r\n  padding: 4em;\r\n}"

      expect(uploaded_files).to eq [
        "#{subject.id}",
        "#{subject.id}/e6df26f541ebad8e8fed26a84e202a7c.css"
      ]

      subject.css = 'body{background-color: red}'
      subject.save!
      expect(subject.css).to eq 'body{background-color: red}'

      expect(uploaded_files).to eq [
        "#{subject.id}",
        "#{subject.id}/b1192d422b8c8999043c2abd1b47b750.css"
      ]
    end
  end

  describe '#email' do
    it 'returns noreply email address' do
      site =  FactoryGirl.create(:site, host: 'example.com')
      expect(site.email).to eq 'noreply@example.com'
    end

    it 'returns host without www' do
      site =  FactoryGirl.create(:site, host: 'www.example.com')
      expect(site.email).to eq 'noreply@example.com'
    end
  end

  describe '#main_menu_pages' do
    subject { FactoryGirl.create(:site) }

    it 'returns empty array when no pages' do
      expect(subject.main_menu_pages).to eq []
    end

    it 'returns pages when page ids' do
      page1 = FactoryGirl.create(:page, site: subject)
      page2 = FactoryGirl.create(:page, site: subject)
      subject.main_menu_page_ids = [page2.id, page1.id]

      expect(subject.main_menu_pages).to eq [page2, page1]
    end
  end

  describe '#store_dir' do
    subject { FactoryGirl.create(:site) }

    it 'includes site id' do
      uploads_store_dir = Rails.application.secrets.uploads_store_dir

      expect(subject.store_dir).to eq "#{uploads_store_dir}/#{subject.id}"
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
