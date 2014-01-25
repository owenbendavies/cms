require 'spec_helper'

describe Site do
  include_context 'new_fields'

  describe 'LAYOUTS' do
    specify {
      Site::LAYOUTS.should eq [
        'one_column',
        'right_sidebar',
        'small_right_sidebar',
        'fluid'
      ]
    }
  end

  describe 'properties' do
    subject { Site.new(
      host: new_host,
      name: new_company_name,
      sub_title: new_catch_phrase,
      asset_host: new_host,
      main_menu: [{'url' => new_page_url, 'text' => new_name}],
      copyright: new_name,
      google_analytics: new_google_analytics,
      charity_number: new_number,
      updated_by: new_id,
      stylesheet_filename: new_filename,
      header_image_filename: new_filename,
      sidebar_html_content: new_message,
    )}

    its(:host) { should eq new_host }
    its(:name) { should eq new_company_name }
    its(:sub_title) { should eq new_catch_phrase }
    its(:layout) { should eq 'one_column' }
    its(:asset_host) { should eq new_host }
    its(:main_menu) { should eq [{'url' => new_page_url, 'text' => new_name}]}
    its(:copyright) { should eq new_name }
    its(:google_analytics) { should eq new_google_analytics }
    its(:charity_number) { should eq new_number }
    its(:updated_by) { should eq new_id }
    its(:stylesheet_filename) { should eq new_filename }
    its(:header_image_filename) { should eq new_filename }
    its(:sidebar_html_content) { should eq new_message }
  end

  describe 'stylesheet' do
    let(:site) { FactoryGirl.build(:site) }
    subject { site.stylesheet }

    its(:url) {
      should eq File.join(
        site.asset_host,
        CarrierWave::Uploader::Base.store_dir,
        site.stylesheet_filename
      )
    }

    its(:fog_directory) { should eq site.fog_directory }
  end

  describe 'header_image' do
    let(:site) { FactoryGirl.build(:site) }
    subject { site.header_image }

    its(:url) {
      should eq File.join(
        site.asset_host,
        CarrierWave::Uploader::Base.store_dir,
        site.header_image_filename
      )
    }

    its(:fog_directory) { should eq site.fog_directory }
  end

  describe '#auto_strip_attributes' do
    subject {
      FactoryGirl.create(:site, name: " #{new_company_name} ", copyright: '')
    }

    its(:name) { should eq new_company_name }
    its(:copyright) { should be_nil }
  end

  describe 'validate' do
    it { should validate_presence_of(:host) }

    it { should validate_presence_of(:name) }

    it { should validate_length_of(:name, maximum: 64) }

    it { should_not allow_values_for(
      :name,
      '<a>bad</a>',
      message: 'HTML not allowed'
    )}

    it { should validate_length_of(:sub_title, maximum: 64) }

    it { should validate_inclusion_of(:layout, in: Site::LAYOUTS) }

    it { should validate_length_of(:copyright, maximum: 64) }

    it { should allow_values_for(
      :google_analytics,
      '',
      'UA-1234-1',
      'UA-123456-1',
      'UA-123456-22'
    )}

    it { should_not allow_values_for(
      :google_analytics,
      'XA-1234-1',
      'UA-1234',
      'UA123',
      'AS'
    )}

    it { should validate_presence_of(:updated_by) }

    it { should allow_values_for(:sidebar_html_content, '<a>html</a>') }
  end

  describe '.by_host' do
    it 'returns site' do
      site = FactoryGirl.create(:site)
      FactoryGirl.create(:site, host: new_host)

      results = CouchPotato.database.view(Site.by_host(key: site.host))
      results.size.should eq 1
      results.first.should eq site
    end
  end

  describe '.find_by_host' do
    before { @site = FactoryGirl.create(:site) }

    it 'finds a site' do
      Site.find_by_host(@site.host).should eq @site
    end

    it 'ignores case' do
      Site.find_by_host(@site.host.upcase).should eq @site
    end

    it 'returns nil when not found' do
      Site.find_by_host(new_host).should be_nil
    end
  end

  describe '#fog_directory' do
    subject { FactoryGirl.build(:site, host: 'www.example.com') }
    its(:fog_directory) { should eq 'test_cms_www_example_com' }
  end

  describe '#css' do
    include_context 'clear_uploaded_files'

    subject { FactoryGirl.build(:site, stylesheet_filename: nil) }

    context 'with css' do
      before do
        subject.css = "body {\r\n  padding: 4em;\r\n}"
        subject.save!
      end

      its(:css) { should eq "body {\r\n  padding: 4em;\r\n}" }
    end

    context 'when empty' do
      its(:css) { should be_nil }
    end
  end

  describe '#css=' do
    include_context 'clear_uploaded_files'

    subject { FactoryGirl.build(:site, stylesheet_filename: nil) }

    it 'strips end of line whitespace' do
      subject.css = "body {\r\n  padding: 4em; \r\n}"
      subject.stylesheet.read.should eq "body {\r\n  padding: 4em;\r\n}"
    end

    it 'converts tabs to spaces' do
      subject.css = "body {\r\n\tpadding: 4em;\r\n}"
      subject.stylesheet.read.should eq "body {\r\n  padding: 4em;\r\n}"
    end

    it 'saves a file' do
      uploaded_files.should eq []

      subject.css = "body {\r\n  padding: 4em;\r\n}"
      subject.save!

      subject.stylesheet_filename.
        should eq 'e6df26f541ebad8e8fed26a84e202a7c.css'

      uploaded_files.should eq ['e6df26f541ebad8e8fed26a84e202a7c.css']
    end

    it 'keeps old version' do
      uploaded_files.should eq []

      subject.css = "body {\r\n  padding: 4em;\r\n}"
      subject.save!

      uploaded_files.should eq ['e6df26f541ebad8e8fed26a84e202a7c.css']

      subject.css = 'body{background-color: red}'
      subject.save!

      uploaded_files.should eq [
        'b1192d422b8c8999043c2abd1b47b750.css',
        'e6df26f541ebad8e8fed26a84e202a7c.css'
      ]
    end
  end
end
