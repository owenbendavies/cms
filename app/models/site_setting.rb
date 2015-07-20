# == Schema Information
#
# Table name: site_settings
#
#  user_id :integer          not null
#  site_id :integer          not null
#  id      :integer          not null, primary key
#
# Indexes
#
#  fk__site_settings_site_id  (site_id)
#  fk__site_settings_user_id  (user_id)
#
# Foreign Keys
#
#  fk_site_settings_site_id  (site_id => sites.id)
#  fk_site_settings_user_id  (user_id => users.id)
#

class SiteSetting < ActiveRecord::Base
  belongs_to :site
  belongs_to :user
end
