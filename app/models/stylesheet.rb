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
