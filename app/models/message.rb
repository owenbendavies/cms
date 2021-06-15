class Message < ApplicationRecord
  include ActionView::Helpers::SanitizeHelper

  # relations
  belongs_to :site

  # before validations
  TEXT_FIELDS = %i[message].freeze
  private_constant :TEXT_FIELDS

  strip_attributes except: TEXT_FIELDS, collapse_spaces: true, replace_newlines: true
  strip_attributes only: TEXT_FIELDS

  # validations
  validates(:site, presence: true)

  validates(:name, length: { minimum: 3, maximum: 64 }, presence: true)

  validates(:email, email_format: true, length: { maximum: 64 }, presence: true)

  validates(:phone, length: { maximum: 32 }, phone: { allow_blank: true })

  validates(:message, length: { maximum: 2048 }, presence: true)

  validate do
    next unless message

    parsed_message = message.delete("'")
    escaped_message = ERB::Util.html_escape(parsed_message)
    stripped_message = strip_tags(parsed_message)

    errors.add(:message, :contains_html) if escaped_message != stripped_message
  end

  validates(:privacy_policy_agreed, if: ->(message) { message.site&.privacy_policy_page_id }, presence: true)
end
