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
#  fk__images_site_id                    (site_id)
#  index_images_on_site_id_and_filename  (site_id,filename) UNIQUE
#  index_images_on_site_id_and_name      (site_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_images_site_id  (site_id => sites.id)
#

class Image < ActiveRecord::Base
  delegate :store_dir, to: :site, allow_nil: true

  has_paper_trail

  mount_uploader :file, ImageUploader, mount_on: :filename

  schema_validations except: [:created_at, :updated_at, :filename]

  strip_attributes collapse_spaces: true
end
