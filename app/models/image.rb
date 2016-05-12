# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  site_id    :integer          not null
#  name       :string(64)       not null
#  filename   :string(40)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  fk__images_site_id                (site_id)
#  index_images_on_filename          (filename) UNIQUE
#  index_images_on_site_id_and_name  (site_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_images_site_id  (site_id => sites.id) ON DELETE => no_action ON UPDATE => no_action
#

class Image < ActiveRecord::Base
  has_paper_trail

  mount_uploader :file, ImageUploader, mount_on: :filename

  scope :ordered, -> { order(:name) }

  schema_validations except: [:created_at, :updated_at, :filename]

  strip_attributes collapse_spaces: true
end
