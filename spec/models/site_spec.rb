# == Schema Information
#
# Table name: sites
#
#  id                    :integer          not null, primary key
#  host                  :string(64)       not null
#  name                  :string(64)       not null
#  sub_title             :string(64)
#  layout                :string(255)      default("one_column")
#  main_menu_page_ids    :string(255)
#  copyright             :string(64)
#  google_analytics      :string(255)
#  charity_number        :string(255)
#  stylesheet_filename   :string(36)
#  header_image_filename :string(36)
#  sidebar_html_content  :text
#  created_by_id         :integer          not null
#  updated_by_id         :integer          not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'rails_helper'

RSpec.describe Site do
  it 'has a stylesheet' do
    site = FactoryGirl.build(:site)
    stylesheet = site.stylesheet

    expect(stylesheet.url).to eq File.join(
      '/',
      CarrierWave::Uploader::Base.store_dir,
      site.stylesheet_filename
    )
  end

  it 'has a header image' do
    site = FactoryGirl.build(:site)
    header_image = site.header_image

    expect(header_image.url).to eq File.join(
      '/',
      CarrierWave::Uploader::Base.store_dir,
      site.header_image_filename
    )
  end

  it 'strips attributes' do
    site = FactoryGirl.create(
      :site,
      name: " #{new_company_name} ",
      copyright: ''
    )

    expect(site.name).to eq new_company_name
    expect(site.copyright).to be_nil
  end

  describe 'validate' do
    it { should validate_presence_of(:host) }

    it { should validate_presence_of(:name) }

    it { should ensure_length_of(:name).is_at_most(64) }

    it {
      should_not allow_value(
        '<a>bad</a>'
      ).for(:name).with_message('HTML not allowed')
    }

    it { should ensure_length_of(:sub_title).is_at_most(64) }

    it { should allow_value('one_column').for(:layout) }
    it { should allow_value('right_sidebar').for(:layout) }
    it { should allow_value('small_right_sidebar').for(:layout) }

    it { should ensure_length_of(:copyright).is_at_most(64) }

    it { should allow_value('').for(:google_analytics) }
    it { should allow_value('UA-1234-1').for(:google_analytics) }
    it { should allow_value('UA-123456-1').for(:google_analytics) }
    it { should allow_value('UA-123456-22').for(:google_analytics) }

    it { should_not allow_value('XA-1234-1').for(:google_analytics) }
    it { should_not allow_value('UA-1234').for(:google_analytics) }
    it { should_not allow_value('UA123').for(:google_analytics) }
    it { should_not allow_value('AS').for(:google_analytics) }

    it { should validate_presence_of(:updated_by) }

    it { should allow_value('<a>html</a>').for(:sidebar_html_content) }
  end

  describe '#css' do
    include_context 'clear_uploaded_files'

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

  describe '#css=' do
    include_context 'clear_uploaded_files'

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

      expect(subject.stylesheet_filename).
        to eq 'e6df26f541ebad8e8fed26a84e202a7c.css'

      expect(uploaded_files).to eq ['e6df26f541ebad8e8fed26a84e202a7c.css']
    end

    it 'deletes old version' do
      expect(uploaded_files).to eq []

      subject.css = "body {\r\n  padding: 4em;\r\n}"
      subject.save!
      expect(subject.css).to eq "body {\r\n  padding: 4em;\r\n}"

      expect(uploaded_files).to eq ['e6df26f541ebad8e8fed26a84e202a7c.css']

      subject.css = 'body{background-color: red}'
      subject.save!
      expect(subject.css).to eq 'body{background-color: red}'

      expect(uploaded_files).to eq ['b1192d422b8c8999043c2abd1b47b750.css']
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
end
