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
#
# Indexes
#
#  fk__pages_site_id                              (site_id)
#  index_pages_on_site_id_and_main_menu_position  (site_id,main_menu_position) UNIQUE
#  index_pages_on_site_id_and_url                 (site_id,url) UNIQUE
#
# Foreign Keys
#
#  fk_pages_site_id  (site_id => sites.id) ON DELETE => no_action ON UPDATE => no_action
#

require 'rails_helper'

RSpec.describe Page, type: :model do
  describe 'acts_as_list' do
    it 'is not added to list by default' do
      expect(FactoryGirl.create(:page)).not_to be_in_list
    end

    it 'is scoped by site' do
      site_1 = FactoryGirl.create(:site)
      site_2 = FactoryGirl.create(:site)

      site_1_page_1 = FactoryGirl.create(:page, site: site_1)
      site_1_page_2 = FactoryGirl.create(:page, site: site_1)
      site_2_page_1 = FactoryGirl.create(:page, site: site_2)
      site_2_page_2 = FactoryGirl.create(:page, site: site_2)

      site_1_page_1.insert_at(1)
      site_1_page_2.insert_at(2)
      site_2_page_1.insert_at(1)
      site_2_page_2.insert_at(2)

      site_1_page_1.reload
      site_1_page_2.reload
      site_2_page_1.reload
      site_2_page_2.reload

      expect(site_1_page_1.main_menu_position).to eq 1
      expect(site_1_page_2.main_menu_position).to eq 2
      expect(site_2_page_1.main_menu_position).to eq 1
      expect(site_2_page_2.main_menu_position).to eq 2
    end
  end

  describe '.valid?' do
    it 'strips html tags' do
      subject = described_class.new
      subject.html_content = '<a href="url" class="link">a link</a><bad>tag</bad>'
      subject.valid?
      expect(subject.html_content).to eq '<a href="url" class="link">a link</a>tag'
    end
  end

  describe '.non_private' do
    it 'returns non private pages' do
      public_page_1 = FactoryGirl.create(:page)
      public_page_2 = FactoryGirl.create(:page)
      FactoryGirl.create(:private_page)

      expect(described_class.non_private).to eq [public_page_1, public_page_2]
    end
  end

  describe '.ordered' do
    it 'returns ordered by name' do
      page_c = FactoryGirl.create(:page, name: 'Page C')
      page_a = FactoryGirl.create(:page, name: 'Page A')
      page_b = FactoryGirl.create(:page, name: 'Page B')

      expect(described_class.ordered).to eq [page_a, page_b, page_c]
    end
  end

  it { is_expected.to strip_attribute(:name).collapse_spaces }
  it { is_expected.not_to strip_attribute(:html_content).collapse_spaces }
  it { is_expected.not_to strip_attribute(:custom_html).collapse_spaces }

  describe '#valid?' do
    it 'validates database schema' do
      should validate_presence_of(:name)
    end

    it { should_not allow_value('login').for(:url) }
  end

  describe '#name=' do
    it 'sets url as downcases name' do
      subject.name = 'Name'
      expect(subject.url).to eq 'name'
    end

    it 'sets url spaces with _' do
      subject.name = 'new name'
      expect(subject.url).to eq 'new_name'
    end

    it 'works when name is nil' do
      subject.name = nil
      expect(subject.url).to be_nil
    end
  end

  describe '#to_param' do
    subject { FactoryGirl.create(:page, name: 'Test Page') }

    it 'uses url' do
      expect(subject.to_param).to eq 'test_page'
    end

    it 'uses unchanged url' do
      subject.url = 'new_page'
      expect(subject.to_param).to eq 'test_page'
    end
  end
end
