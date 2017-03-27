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

class FooterLink < ApplicationRecord
  acts_as_list scope: :site

  schema_validations except: %i(position created_at updated_at)

  strip_attributes collapse_spaces: true, replace_newlines: true

  validates :url, url: true
end
