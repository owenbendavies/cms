# == Schema Information
#
# Table name: images
#
#  id            :integer          not null, primary key
#  site_id       :integer          not null
#  name          :string(64)       not null
#  filename      :string(36)
#  created_by_id :integer          not null
#  updated_by_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Image < ActiveRecord::Base
  belongs_to :site
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  delegate :store_dir, to: :site, allow_nil: true

  has_paper_trail

  mount_uploader :file, ImageUploader, mount_on: :filename

  strip_attributes collapse_spaces: true

  auto_validate
  validates :name, length: { maximum: 64 }, uniqueness: { scope: :site_id }
  validates :filename, uniqueness: { scope: :site_id }
end
