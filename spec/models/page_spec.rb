# == Schema Information
#
# Table name: pages
#
#  id                 :integer          not null, primary key
#  site_id            :integer          not null
#  url                :string(64)       not null
#  name               :string(64)       not null
#  private            :boolean          default(FALSE), not null
#  contact_form       :boolean          default(FALSE), not null
#  html_content       :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  main_menu_position :integer
#  custom_html        :text
#  hidden             :boolean          default(FALSE), not null
#
# Indexes
#
#  index_pages_on_site_id                         (site_id)
#  index_pages_on_site_id_and_main_menu_position  (site_id,main_menu_position) UNIQUE
#  index_pages_on_site_id_and_url                 (site_id,url) UNIQUE
#
# Foreign Keys
#
#  fk_pages_site_id  (site_id => sites.id)
#

require 'rails_helper'

RSpec.describe Page do
  describe 'acts_as_list' do
    let(:site1) { FactoryBot.create(:site) }
    let(:site2) { FactoryBot.create(:site) }

    it 'is not added to list by default' do
      expect(FactoryBot.create(:page)).not_to be_in_list
    end

    it 'is scoped by site' do
      page1 = FactoryBot.create(:page, site: site1)
      page2 = FactoryBot.create(:page, site: site2)
      page1.insert_at(1)
      page2.insert_at(1)

      expect(page1.reload.main_menu_position).to eq 1
    end
  end

  describe 'relations' do
    it { is_expected.to belong_to(:site) }
  end

  describe 'scopes' do
    describe '.ordered' do
      it 'returns ordered by name' do
        page_c = FactoryBot.create(:page, name: 'Page C')
        page_a = FactoryBot.create(:page, name: 'Page A')
        page_b = FactoryBot.create(:page, name: 'Page B')

        expect(described_class.ordered).to eq [page_a, page_b, page_c]
      end
    end

    describe '.visible' do
      it 'returns non hidden or private pages' do
        page1 = FactoryBot.create(:page)
        page2 = FactoryBot.create(:page)
        FactoryBot.create(:page, :private)
        FactoryBot.create(:page, :hidden)

        expect(described_class.visible).to contain_exactly(page1, page2)
      end
    end
  end

  describe 'before validations' do
    subject(:page) { described_class.new }

    it { is_expected.to strip_attribute(:name).collapse_spaces }
    it { is_expected.not_to strip_attribute(:html_content).collapse_spaces }
    it { is_expected.not_to strip_attribute(:custom_html).collapse_spaces }

    it 'strips html tags' do
      page.html_content = '<a href="url" class="link">a link</a><bad>tag</bad>'
      page.valid?
      expect(page.html_content).to eq '<a href="url" class="link">a link</a>tag'
    end
  end

  describe 'validations' do
    it 'validates database schema' do
      is_expected.to validate_presence_of(:name)
    end

    it { is_expected.not_to allow_value('login').for(:url) }
  end

  describe '#name=' do
    subject(:page) { described_class.new }

    it 'sets url as downcases name' do
      page.name = 'Name'
      expect(page.url).to eq 'name'
    end

    it 'sets url spaces with _' do
      page.name = 'new name'
      expect(page.url).to eq 'new_name'
    end

    it 'works when name is nil' do
      page.name = nil
      expect(page.url).to be_nil
    end
  end

  describe '#to_param' do
    subject(:page) { FactoryBot.create(:page, name: 'Test Page') }

    it 'uses url' do
      expect(page.to_param).to eq 'test_page'
    end

    it 'uses unchanged url' do
      page.url = 'new_page'
      expect(page.to_param).to eq 'test_page'
    end
  end
end
