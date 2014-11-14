require 'rails_helper'

RSpec.describe Page do
  it 'has accessors for its properties' do
    page = Page.new(
      site_id: new_id,
      url: new_page_url,
      name: new_name,
      contact_form: true,
      created_by: new_id,
      updated_by: new_id,
      html_content: new_message,
    )

    expect(page.site_id).to eq new_id
    expect(page.url).to eq new_page_url
    expect(page.name).to eq new_name
    expect(page.private).to eq false
    expect(page.contact_form).to eq true
    expect(page.created_by).to eq new_id
    expect(page.updated_by).to eq new_id
    expect(page.html_content).to eq new_message
    expect(page.to_param).to eq new_page_url
  end

  it 'strips attributes' do
    page = FactoryGirl.create(
      :page,
      name: "  #{new_name} ",
    )

    expect(page.name).to eq new_name
  end

  it 'does not strip html_content' do
    text = "  #{new_message}"

    page = FactoryGirl.create(
      :page,
      html_content: text,
    )

    expect(page.html_content).to eq text
  end

  describe 'on save' do
    it 'sets updated_at to now' do
      page = FactoryGirl.build(:page)
      time = Time.now

      Timecop.freeze(time) do
        page.save!
      end

      expect(page.updated_at).to eq time.to_s
    end

    it 'sets url from name' do
      page = FactoryGirl.build(:page, name: 'Test Page')
      page.save!

      expect(page.name).to eq 'Test Page'
      expect(page.url).to eq 'test_page'
    end
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
