# == Schema Information
#
# Table name: site_settings
#
#  user_id    :integer          not null
#  site_id    :integer          not null
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  fk__site_settings_site_id                   (site_id)
#  fk__site_settings_user_id                   (user_id)
#  index_site_settings_on_user_id_and_site_id  (user_id,site_id) UNIQUE
#
# Foreign Keys
#
#  fk_site_settings_site_id  (site_id => sites.id)
#  fk_site_settings_user_id  (user_id => users.id)
#

class SiteSetting < ActiveRecord::Base
  belongs_to :site
  belongs_to :user

  has_paper_trail
end
