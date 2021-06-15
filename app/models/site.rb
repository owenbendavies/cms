class Site < ApplicationRecord
  include Rails.application.routes.url_helpers

  # relations
  has_many :images, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :pages, dependent: :destroy
  belongs_to :privacy_policy_page, class_name: 'Page', optional: true

  has_many(:main_menu_pages, -> { in_list.order(:main_menu_position) }, class_name: 'Page', inverse_of: :site)

  # before validations
  TEXT_FIELDS = %i[sidebar_html_content css].freeze
  private_constant :TEXT_FIELDS

  strip_attributes except: TEXT_FIELDS, collapse_spaces: true, replace_newlines: true
  strip_attributes only: TEXT_FIELDS

  # validations
  validates(:host, length: { maximum: 64 }, presence: true, uniqueness: true)

  validates(:name, length: { minimum: 3, maximum: 64 }, presence: true)

  validates(
    :google_analytics,
    format: { with: /\AUA-[0-9]+-[0-9]{1,2}\z/, allow_nil: true },
    length: { allow_nil: true, maximum: 32 }
  )

  validates(:charity_number, length: { allow_nil: true, maximum: 32 })

  validates(:links, json: { schema: Rails.root.join('config/json_schemas/site_links.json').to_s })

  def address
    root_url(url_options)
  end

  def url_options
    {
      host: host,
      protocol: Rails.configuration.x.disable_ssl ? 'http' : 'https',
      port: Rails.configuration.x.email_link_port
    }
  end
end
