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

class Image < ActiveRecord::Base
  belongs_to :site
  belongs_to :created_by, class_name: 'Account'
  belongs_to :updated_by, class_name: 'Account'

  delegate :store_dir, to: :site

  mount_uploader :file, ImageUploader, mount_on: :filename

  strip_attributes collapse_spaces: true

  validates *attribute_names, no_html: true
  validates :site_id, presence: true
  validates :name, presence: true, length: { maximum: 64 }
  validates :created_by, presence: true
  validates :updated_by, presence: true
end
