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
#  fk__site_settings_created_by_id  (created_by_id)
#  fk__site_settings_site_id        (site_id)
#  fk__site_settings_updated_by_id  (updated_by_id)
#  fk__site_settings_user_id        (user_id)
#
# Foreign Keys
#
#  fk_site_settings_created_by_id  (created_by_id => users.id)
#  fk_site_settings_site_id        (site_id => sites.id)
#  fk_site_settings_updated_by_id  (updated_by_id => users.id)
#  fk_site_settings_user_id        (user_id => users.id)
#

class SiteSetting < ActiveRecord::Base
  belongs_to :site
  belongs_to :user
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'
end
