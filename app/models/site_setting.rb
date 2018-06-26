class SiteSetting < ApplicationRecord
  # relations
  belongs_to :site
  belongs_to :user

  # validations
  validates(
    :site,
    presence: true,
    uniqueness: { scope: :user_id }
  )

  validates(
    :user,
    presence: true
  )
end
