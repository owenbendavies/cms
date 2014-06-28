require 'spec_helper'

describe Site do
  include_context 'new_fields'

  describe 'LAYOUTS' do
    specify {
      expect(Site::LAYOUTS).to eq [
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
      css_filename: new_filename,
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
    its(:css_filename) { should eq new_filename }
    its(:header_image_filename) { should eq new_filename }
    its(:sidebar_html_content) { should eq new_message }
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
      expect(results.size).to eq 1
      expect(results.first).to eq site
    end
  end

  describe '.by_css_filename' do
    it 'returns site' do
      site = FactoryGirl.build(:site)
      site.css = "body {\r\n  padding: 4em;\r\n}"
      site.save!

      results = CouchPotato.database.view(
        Site.by_css_filename(key: site.css_filename)
      )
      expect(results.size).to eq 1
      expect(results.first).to eq site
    end
  end

  describe '.find_by_host' do
    before { @site = FactoryGirl.create(:site) }

    it 'finds a site' do
      expect(Site.find_by_host(@site.host)).to eq @site
    end

    it 'ignores case' do
      expect(Site.find_by_host(@site.host.upcase)).to eq @site
    end

    it 'returns nil when not found' do
      expect(Site.find_by_host(new_host)).to be_nil
    end
  end

  describe '.find_by_css_filename' do
    before do
      @site = FactoryGirl.build(:site)
      @site.css = "body {\r\n  padding: 4em;\r\n}"
      @site.save!
    end

    it 'finds a site' do
      expect(Site.find_by_css_filename(@site.css_filename)).to eq @site
    end

    it 'returns nil when not found' do
      expect(Site.find_by_css_filename(new_filename)).to be_nil
    end
  end

  describe '#fog_directory' do
    subject { FactoryGirl.build(:site, host: 'www.example.com') }
    its(:fog_directory) { should eq 'test_cms_www_example_com' }
  end

  describe '#css' do
    subject { FactoryGirl.build(:site) }

    context 'with css' do
      before do
        subject.css = "body {\r\n  padding: 4em;\r\n}"
        subject.save!
      end

      its(:css) { should eq "body {\r\n  padding: 4em;\r\n}" }

      its(:css_filename) { should eq 'e6df26f541ebad8e8fed26a84e202a7c.css' }

      it 'saves css as attachment' do
        expect(subject._attachments.size).to eq 1
        attachment = subject._attachments['css']
        expect(attachment['content_type']).to eq 'text/css'
      end
    end

    context 'when empty' do
      its(:css) { should be_nil }
    end
  end

  describe '#css=' do
    subject { FactoryGirl.build(:site) }

    it 'strips end of line whitespace' do
      subject.css = "body {\r\n  padding: 4em; \r\n}"
      subject.save!
      expect(subject.css).to eq "body {\r\n  padding: 4em;\r\n}"
    end

    it 'converts tabs to spaces' do
      subject.css = "body {\r\n\tpadding: 4em;\r\n}"
      subject.save!
      expect(subject.css).to eq "body {\r\n  padding: 4em;\r\n}"
    end
  end
end
