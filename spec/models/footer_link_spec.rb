# == Schema Information
#
# Table name: footer_links
#
#  id         :integer          not null, primary key
#  site_id    :integer          not null
#  position   :integer          not null
#  name       :string           not null
#  url        :string           not null
#  icon       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  fk__footer_links_site_id                    (site_id)
#  index_footer_links_on_site_id_and_position  (site_id,position) UNIQUE
#
# Foreign Keys
#
#  fk_footer_links_site_id  (site_id => sites.id) ON DELETE => no_action ON UPDATE => no_action
#

require 'rails_helper'

RSpec.describe FooterLink do
  describe 'acts_as_list' do
    let(:site1) { FactoryGirl.create(:site) }
    let(:site2) { FactoryGirl.create(:site) }

    it 'is scoped by site' do
      FactoryGirl.create(:footer_link, site: site1)
      link = FactoryGirl.create(:footer_link, site: site2)
      expect(link.position).to eq 1
    end

    it 'apends new items' do
      FactoryGirl.create(:footer_link, site: site1)
      link = FactoryGirl.create(:footer_link, site: site1)
      expect(link.position).to eq 2
    end
  end

  it { is_expected.to strip_attribute(:name).collapse_spaces }
  it { is_expected.to strip_attribute(:url).collapse_spaces }
  it { is_expected.to strip_attribute(:icon).collapse_spaces }

  describe '#valid?' do
    it 'validates database schema' do
      is_expected.to validate_presence_of(:name)
    end

    it { is_expected.to allow_value('https://www.example.com').for(:url) }
    it { is_expected.not_to allow_value('bad').for(:url).with_message('is not a valid URL') }
  end
end
