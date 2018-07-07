class Site < ApplicationRecord
  include DefaultUid

  # relations
  has_many :images, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :pages, dependent: :destroy
  has_one :stylesheet, dependent: :destroy
  belongs_to :privacy_policy_page, class_name: 'Page', optional: true

  has_many(
    :main_menu_pages,
    -> { in_list.order(:main_menu_position) },
    class_name: 'Page',
    inverse_of: :site
  )

  # scopes
  scope(:ordered, -> { order(:host) })

  # before validations
  strip_attributes except: :sidebar_html_content, collapse_spaces: true, replace_newlines: true

  # validations
  validates(
    :host,
    length: { maximum: 64 },
    presence: true,
    uniqueness: true
  )

  validates(
    :name,
    length: { minimum: 3, maximum: 64 },
    presence: true
  )

  validates(
    :google_analytics,
    format: { with: /\AUA-[0-9]+-[0-9]{1,2}\z/, allow_blank: true },
    length: { allow_nil: true, maximum: 32 }
  )

  validates(
    :charity_number,
    length: { allow_nil: true, maximum: 32 }
  )

  validates(
    :links,
    json: { schema: Rails.root.join('config', 'json_schemas', 'site_links.json').to_s }
  )

  def address
    protocol = ENV['DISABLE_SSL'] ? 'http' : 'https'
    "#{protocol}://#{host}"
  end

  def email
    "noreply@#{host.gsub(/^www\./, '')}"
  end

  def user_emails
    AWS_COGNITO.list_users_in_group(
      user_pool_id: ENV.fetch('AWS_COGNITO_USER_POOL_ID'),
      group_name: host
    ).users.map do |user|
      user.attributes.find { |attribute| attribute.name == 'email' }.value
    end
  end
end
