# == Schema Information
#
# Table name: site_settings
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  site_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  admin      :boolean          default(FALSE), not null
#
# Indexes
#
#  fk__site_settings_site_id                   (site_id)
#  fk__site_settings_user_id                   (user_id)
#  index_site_settings_on_user_id_and_site_id  (user_id,site_id) UNIQUE
#
# Foreign Keys
#
#  fk_site_settings_site_id  (site_id => sites.id) ON DELETE => no_action ON UPDATE => no_action
#  fk_site_settings_user_id  (user_id => users.id) ON DELETE => no_action ON UPDATE => no_action
#

require 'rails_helper'

RSpec.describe SiteSetting do
  describe '#valid?' do
    it 'validates database schema' do
      should validate_presence_of(:user)
    end
  end
end
