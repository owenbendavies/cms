require 'rails_helper'

RSpec.describe Page do
  it_behaves_like 'model with versioning'

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
    it { is_expected.to have_one(:privacy_policy_site).dependent(:nullify) }
  end

  describe 'scopes' do
    describe '.non_private' do
      it 'returns non private pages' do
        page1 = FactoryBot.create(:page)
        page2 = FactoryBot.create(:page)
        FactoryBot.create(:page, private: true)

        expect(described_class.non_private).to contain_exactly(page1, page2)
      end
    end

    describe '.ordered' do
      it 'returns ordered by name' do
        page_c = FactoryBot.create(:page, name: 'Page C')
        page_a = FactoryBot.create(:page, name: 'Page A')
        page_b = FactoryBot.create(:page, name: 'Page B')

        expect(described_class.ordered).to eq [page_a, page_b, page_c]
      end
    end
  end

  describe 'before validations' do
    subject(:page) { described_class.new }

    it { is_expected.to strip_attribute(:name).collapse_spaces }
    it { is_expected.to strip_attribute(:html_content) }
    it { is_expected.to strip_attribute(:custom_html) }

    it 'strips html tags' do
      page.html_content = '<a href="url" class="link">a link</a><bad>tag</bad>'
      page.valid?
      expect(page.html_content).to eq '<a href="url">a link</a>tag'
    end
  end

  describe 'validations' do
    subject { FactoryBot.build :page }

    it { is_expected.to validate_presence_of(:site) }

    it { is_expected.not_to allow_value('login').for(:url) }
    it { is_expected.to validate_length_of(:url).is_at_most(64) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_uniqueness_of(:url).scoped_to(:site_id) }

    it { is_expected.to validate_length_of(:name).is_at_most(64) }
    it { is_expected.to validate_presence_of(:name) }
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
