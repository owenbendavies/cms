# == Schema Information
#
# Table name: stylesheets
#
#  id         :integer          not null, primary key
#  site_id    :integer          not null
#  css        :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_stylesheets_on_site_id  (site_id) UNIQUE
#
# Foreign Keys
#
#  fk_stylesheets_site_id  (site_id => sites.id)
#

class Stylesheet < ApplicationRecord
  # relations
  belongs_to :site

  # validations
  validates(
    :site,
    presence: true
  )

  validates(
    :css,
    presence: true
  )
end
