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
#
# Indexes
#
#  fk__pages_site_id                              (site_id)
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
    it 'is not added to list by default' do
      expect(FactoryGirl.create(:page)).to_not be_in_list
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

  it { should belong_to(:site) }

  it 'is versioned', versioning: true do
    is_expected.to be_versioned
  end

  it { is_expected.to strip_attribute(:name).collapse_spaces }
  it { is_expected.to_not strip_attribute(:html_content).collapse_spaces }

  describe 'validate' do
    subject { FactoryGirl.build(:page) }

    it { should validate_presence_of(:site) }

    it { should validate_presence_of(:url) }
    it { should validate_uniqueness_of(:url).scoped_to(:site_id) }

    %w(health login logout new robots site sitemap timeout user).each do |value|
      it { should_not allow_value(value).for(:url) }
    end

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(64) }
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
