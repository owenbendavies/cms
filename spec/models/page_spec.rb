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

    it { should validate_length_of(:name, maximum: 64) }

    it { should_not allow_values_for(
      :name,
      '<a>bad</a>',
      message: 'HTML not allowed'
    )}

    it { should_not allow_values_for(
      :name,
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
    )}

    it { should allow_values_for(
      :bottom_section,
      'contact_form',
      allow_nil: true
    )}

    it { should_not allow_values_for(:bottom_section, 'bad') }

    it { should validate_presence_of(:created_by) }

    it { should validate_presence_of(:updated_by) }

    it { should allow_values_for(:html_content, '<a>html</a>') }
  end

  describe '.by_site_id_and_url' do
    it 'returns page' do
      page = FactoryGirl.create(:page, site_id: new_id)
      FactoryGirl.create(:page, site_id: new_id)

      results = CouchPotato.database.view(
        Page.by_site_id_and_url(key: [new_id, page.url])
      )

      results.size.should eq 1
      results.first.url.should eq page.url
      results.first.html_content.should eq page.html_content
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

      results.size.should eq 1
      results.first.url.should eq @page.url
      results.first.name.should eq @page.name
      results.first.private.should eq false
      results.first.updated_at.should eq time.to_s
      results.first.updated_by.should eq @page.updated_by
      results.first.html_content.should be_nil
    end
  end

  describe '.find_by_site_and_url' do
    before {
      @site = FactoryGirl.create(:site)
      @page = FactoryGirl.create(:page, site_id: @site.id)
    }

    it 'finds a page' do
      Page.find_by_site_and_url(@site, @page.url).should eq @page
    end

    it 'returns nil when not found' do
      Page.find_by_site_and_url(@site, new_page_url).should be_nil
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
      pages.size.should eq 1
      page = pages.first
      page.url.should eq @page.url
      page.name.should eq @page.name
      page.private.should eq @page.private
      page.updated_at.should eq time.to_s
      page.updated_by.should eq @page.updated_by
      page.html_content.should be_nil
    end
  end

  describe '#new_url' do
    it 'downcases name' do
      subject.name = 'Name'
      subject.new_url.should eq 'name'
    end

    it 'replaces spaces with _' do
      subject.name = 'new name'
      subject.new_url.should eq 'new_name'
    end

    it 'works when name is nil' do
      subject.name = nil
      subject.new_url.should eq ''
    end
  end
end
