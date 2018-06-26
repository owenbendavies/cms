class Message < ApplicationRecord
  include ActionView::Helpers::SanitizeHelper

  class Entity < Grape::Entity
    expose :uid, documentation: { type: String }
    expose :name, documentation: { type: String }
    expose :email, documentation: { type: String }
    expose :phone, documentation: { type: String }
    expose :message, documentation: { type: String }
    expose :privacy_policy_agreed, documentation: { type: Grape::API::Boolean }
    expose :created_at, documentation: { type: DateTime }
    expose :updated_at, documentation: { type: DateTime }
  end

  include DefaultUid

  attr_accessor :do_not_fill_in

  # relations
  belongs_to :site

  # scopes
  scope(:ordered, -> { order(created_at: :desc) })

  # before validations
  strip_attributes except: :message, collapse_spaces: true, replace_newlines: true

  # validations
  validates(
    :site,
    presence: true
  )

  validates(
    :name,
    length: { minimum: 3, maximum: 64 },
    presence: true
  )

  validates(
    :email,
    email_format: true,
    length: { maximum: 64 },
    presence: true
  )

  validates(
    :phone,
    length: { maximum: 32 },
    phone: { allow_blank: true }
  )

  validates(
    :message,
    length: { maximum: 2048 },
    presence: true
  )

  validate do
    next unless message
    parsed_message = message.delete("'")
    escaped_message = ERB::Util.html_escape(parsed_message)
    stripped_message = strip_tags(parsed_message)

    errors.add(:message, :contains_html) if escaped_message != stripped_message
  end

  validates(
    :do_not_fill_in,
    length: { maximum: 0 }
  )

  validates(
    :privacy_policy_agreed,
    if: ->(message) { message.site&.privacy_policy_page_id },
    presence: true
  )
end
