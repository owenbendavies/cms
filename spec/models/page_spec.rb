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

require 'rails_helper'

RSpec.describe Page do
  it 'strips attributes' do
    page = FactoryGirl.create(:page, name: "  #{new_name} ")

    expect(page.name).to eq new_name
  end

  it 'does not strip html_content' do
    text = "  #{new_message}"

    page = FactoryGirl.create(
      :page,
      html_content: text
    )

    expect(page.html_content).to eq text
  end

  describe 'on save' do
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

    it do
      should_not allow_value(
        '<a>bad</a>'
      ).for(:name).with_message('HTML not allowed')
    end

    [
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
      'sitemap'
    ].each do |value|
      it { should_not allow_value(value).for(:name) }
    end

    it { should validate_presence_of(:created_by) }

    it { should validate_presence_of(:updated_by) }

    it { should allow_value('<a>html</a>').for(:html_content) }
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

  describe '#to_param' do
    it 'uses url' do
      subject.url = 'test_page'
      expect(subject.to_param).to eq 'test_page'
    end
  end
end
