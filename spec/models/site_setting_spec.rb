# == Schema Information
#
# Table name: site_settings
#
#  user_id       :integer          not null
#  site_id       :integer          not null
#  id            :integer          not null, primary key
#  created_by_id :integer          not null
#  updated_by_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  fk__site_settings_created_by_id             (created_by_id)
#  fk__site_settings_site_id                   (site_id)
#  fk__site_settings_updated_by_id             (updated_by_id)
#  fk__site_settings_user_id                   (user_id)
#  index_site_settings_on_user_id_and_site_id  (user_id,site_id) UNIQUE
#
# Foreign Keys
#
#  fk_site_settings_created_by_id  (created_by_id => users.id)
#  fk_site_settings_site_id        (site_id => sites.id)
#  fk_site_settings_updated_by_id  (updated_by_id => users.id)
#  fk_site_settings_user_id        (user_id => users.id)
#

require 'rails_helper'

RSpec.describe SiteSetting do
  it { should belong_to(:site) }
  it { should belong_to(:user) }
  it { should belong_to(:created_by).class_name('User') }
  it { should belong_to(:updated_by).class_name('User') }

  it 'is versioned', versioning: true do
    is_expected.to be_versioned
  end

  describe 'validate' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:site) }
  end
end
