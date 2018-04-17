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
#  index_images_on_filename          (filename) UNIQUE
#  index_images_on_site_id           (site_id)
#  index_images_on_site_id_and_name  (site_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_images_site_id  (site_id => sites.id)
#

class Image < ApplicationRecord
  mount_uploader :file, ImageUploader, mount_on: :filename

  # relations
  belongs_to :site

  # scopes
  scope(:ordered, -> { order(:name) })

  # before validations
  strip_attributes collapse_spaces: true, replace_newlines: true

  # validations
  schema_validations except: %i[created_at updated_at filename]
end
