require 'spec_helper'

describe Page do
  include_context 'new_fields'

  describe 'properties' do
    subject { Page.new(
      site_id: new_id,
      url: new_page_url,
      name: new_name,
      bottom_section: 'contact_form',
      created_by: new_id,
      updated_by: new_id,
      html_content: new_message,
    )}

    its(:site_id) { should eq new_id }
    its(:url) { should eq new_page_url }
    its(:name) { should eq new_name }
    its(:private) { should eq false }
    its(:bottom_section) { should eq 'contact_form' }
    its(:created_by) { should eq new_id }
    its(:updated_by) { should eq new_id }
    its(:html_content) { should eq new_message }
    its(:to_param) { should eq new_page_url }
  end

  context 'saved page' do
    subject { FactoryGirl.build(:page) }
    let(:time) { Time.now }

    before do
      Timecop.freeze(time) do
        subject.save!
      end
    end

    its(:updated_at) { should eq time.to_s }
  end

  describe 'auto_strip_attributes' do
    subject {
      FactoryGirl.create(:page,
        name: "  #{new_name} ",
        html_content: "  #{new_message} ",
      )
    }

    its(:name) { should eq new_name }
    its(:html_content) { should eq "  #{new_message} " }
  end

  context 'updated name' do
    subject { FactoryGirl.build(:page, name: 'Test Page') }
    before { subject.save! }

    its(:name) { should eq 'Test Page' }
    its(:url) { should eq 'test_page' }
  end

  describe 'validate' do
    it { should validate_presence_of(:site_id) }

    it { should validate_presence_of(:name) }

    it { should ensure_length_of(:name).is_at_most(64) }

    it {
      should_not allow_value(
        '<a>bad</a>'
      ).for(:name).with_message('HTML not allowed')
    }

    it {
      should_not allow_value(
        '@',
        'NEW',
        'New',
        'account',
        'health',
        'login',
        'logout',
        'new',
        'robots',
        'site',
        'sitemap',
        'stylesheets',
      ).for(:name)
    }

    it { should allow_value('contact_form').for(:bottom_section) }

    it { should_not allow_value('bad').for(:bottom_section) }

    it { should validate_presence_of(:created_by) }

    it { should validate_presence_of(:updated_by) }

    it { should allow_value('<a>html</a>').for(:html_content) }
  end

  describe '.by_site_id_and_url' do
    it 'returns page' do
      page = FactoryGirl.create(:page, site_id: new_id)
      FactoryGirl.create(:page, site_id: new_id)

      results = CouchPotato.database.view(
        Page.by_site_id_and_url(key: [new_id, page.url])
      )

      expect(results.size).to eq 1
      expect(results.first.url).to eq page.url
      expect(results.first.html_content).to eq page.html_content
    end
  end

  describe '.link_by_site_id_and_url' do
    let(:time) { Time.now }

    it 'returns properties needed for links' do
      Timecop.freeze(time) do
        @page = FactoryGirl.create(:page, site_id: new_id)
      end

      FactoryGirl.create(:page, site_id: new_id)

      results = CouchPotato.database.view(
        Page.link_by_site_id_and_url(key: [new_id, @page.url])
      )

      expect(results.size).to eq 1
      expect(results.first.url).to eq @page.url
      expect(results.first.name).to eq @page.name
      expect(results.first.private).to eq false
      expect(results.first.updated_at).to eq time.to_s
      expect(results.first.updated_by).to eq @page.updated_by
      expect(results.first.html_content).to be_nil
    end
  end

  describe '.find_by_site_and_url' do
    before {
      @site = FactoryGirl.create(:site)
      @page = FactoryGirl.create(:page, site_id: @site.id)
    }

    it 'finds a page' do
      expect(Page.find_by_site_and_url(@site, @page.url)).to eq @page
    end

    it 'returns nil when not found' do
      expect(Page.find_by_site_and_url(@site, new_page_url)).to be_nil
    end
  end

  describe '.find_all_links_by_site' do
    let(:time) { Time.now }
    let(:site) { FactoryGirl.create(:site) }

    before {
      Timecop.freeze(time) do
        @page = FactoryGirl.create(:page, site_id: site.id)
        FactoryGirl.create(:page)
      end
    }

    it 'returns all page links' do
      pages = Page.find_all_links_by_site(site)
      expect(pages.size).to eq 1
      page = pages.first
      expect(page.url).to eq @page.url
      expect(page.name).to eq @page.name
      expect(page.private).to eq @page.private
      expect(page.updated_at).to eq time.to_s
      expect(page.updated_by).to eq @page.updated_by
      expect(page.html_content).to be_nil
    end
  end

  describe '#new_url' do
    it 'downcases name' do
      subject.name = 'Name'
      expect(subject.new_url).to eq 'name'
    end

    it 'replaces spaces with _' do
      subject.name = 'new name'
      expect(subject.new_url).to eq 'new_name'
    end

    it 'works when name is nil' do
      subject.name = nil
      expect(subject.new_url).to eq ''
    end
  end
end
