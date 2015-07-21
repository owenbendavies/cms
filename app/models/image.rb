# == Schema Information
#
# Table name: images
#
#  id            :integer          not null, primary key
#  site_id       :integer          not null
#  name          :string(64)       not null
#  filename      :string(36)       not null
#  created_by_id :integer          not null
#  updated_by_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  fk__images_created_by_id              (created_by_id)
#  fk__images_site_id                    (site_id)
#  fk__images_updated_by_id              (updated_by_id)
#  index_images_on_site_id_and_filename  (site_id,filename) UNIQUE
#  index_images_on_site_id_and_name      (site_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_images_created_by_id  (created_by_id => users.id)
#  fk_images_site_id        (site_id => sites.id)
#  fk_images_updated_by_id  (updated_by_id => users.id)
#

class Image < ActiveRecord::Base
  belongs_to :site
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  delegate :store_dir, to: :site, allow_nil: true

  has_paper_trail

  mount_uploader :file, ImageUploader, mount_on: :filename

  strip_attributes collapse_spaces: true
end
