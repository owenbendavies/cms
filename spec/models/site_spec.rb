require 'rails_helper'

RSpec.describe Site do
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

  it 'has accessors for its properties' do
    site = Site.new(
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
    )

    expect(site.host).to eq new_host
    expect(site.name).to eq new_company_name
    expect(site.sub_title).to eq new_catch_phrase
    expect(site.layout).to eq 'one_column'
    expect(site.asset_host).to eq new_host
    expect(site.main_menu).to eq [{'url' => new_page_url, 'text' => new_name}]
    expect(site.copyright).to eq new_name
    expect(site.google_analytics).to eq new_google_analytics
    expect(site.charity_number).to eq new_number
    expect(site.updated_by).to eq new_id
    expect(site.css_filename).to eq new_filename
    expect(site.header_image_filename).to eq new_filename
    expect(site.sidebar_html_content).to eq new_message
  end

  it 'has a header image' do
    site = FactoryGirl.build(:site)
    header_image = site.header_image

    expect(header_image.url).to eq File.join(
      site.asset_host,
      CarrierWave::Uploader::Base.store_dir,
      site.header_image_filename
    )

    expect(header_image.fog_directory).to eq site.fog_directory
  end

  it 'auto strips attributes' do
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

    it {
      should allow_value(
        'one_column',
        'right_sidebar',
        'small_right_sidebar',
        'fluid',
      ).for(:layout)
    }

    it { should ensure_length_of(:copyright).is_at_most(64) }

    it {
      should allow_value(
        '',
        'UA-1234-1',
        'UA-123456-1',
        'UA-123456-22'
      ).for(:google_analytics)
    }

    it {
      should_not allow_value(
        'XA-1234-1',
        'UA-1234',
        'UA123',
        'AS'
      ).for(:google_analytics)
    }

    it { should validate_presence_of(:updated_by) }

    it { should allow_value('<a>html</a>').for(:sidebar_html_content) }
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

    it 'is based on host and environment' do
      expect(subject.fog_directory).to eq 'test_cms_www_example_com'
    end
  end

  describe '#css' do
    subject { FactoryGirl.build(:site) }

    context 'with css' do
      before do
        subject.css = "body {\r\n  padding: 4em;\r\n}"
        subject.save!
      end

      it 'returns css' do
        expect(subject.css).to eq "body {\r\n  padding: 4em;\r\n}"
      end

      it 'returns css_filename' do
        expect(subject.css_filename).
          to eq 'e6df26f541ebad8e8fed26a84e202a7c.css'
      end

      it 'saves css as attachment' do
        expect(subject._attachments.size).to eq 1
        attachment = subject._attachments['css']
        expect(attachment['content_type']).to eq 'text/css'
      end
    end

    context 'when empty' do
      it 'returns nil' do
        expect(subject.css).to be_nil
      end
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
