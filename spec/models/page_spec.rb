# == Schema Information
#
# Table name: pages
#
#  id            :integer          not null, primary key
#  site_id       :integer          not null
#  url           :string(64)       not null
#  name          :string(64)       not null
#  private       :boolean          default(FALSE), not null
#  contact_form  :boolean          default(FALSE), not null
#  html_content  :text
#  created_by_id :integer          not null
#  updated_by_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  fk__pages_created_by_id         (created_by_id)
#  fk__pages_site_id               (site_id)
#  fk__pages_updated_by_id         (updated_by_id)
#  index_pages_on_site_id_and_url  (site_id,url) UNIQUE
#
# Foreign Keys
#
#  fk_pages_created_by_id  (created_by_id => users.id)
#  fk_pages_site_id        (site_id => sites.id)
#  fk_pages_updated_by_id  (updated_by_id => users.id)
#

require 'rails_helper'

RSpec.describe Page do
  it { should belong_to(:site) }
  it { should belong_to(:created_by).class_name('User') }
  it { should belong_to(:updated_by).class_name('User') }

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

    %w(
      health
      login
      logout
      new
      robots
      site
      sitemap
      timeout
      users
    ).each do |value|
      it { should_not allow_value(value).for(:url) }
    end

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(64) }

    it { should validate_presence_of(:created_by) }
    it { should validate_presence_of(:updated_by) }
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
      expect(subject.url).to eq nil
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
