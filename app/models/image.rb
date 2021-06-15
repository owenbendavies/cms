class Image < ApplicationRecord
  mount_uploader :file, ImageUploader, mount_on: :filename

  # relations
  belongs_to :site

  # scopes
  scope(:ordered, -> { order(:name) })

  # before validations
  strip_attributes collapse_spaces: true, replace_newlines: true

  # validations
  validates(:site, presence: true)

  validates(:name, length: { maximum: 64 }, presence: true, uniqueness: { scope: :site_id })

  validates(:filename, uniqueness: true)
end
