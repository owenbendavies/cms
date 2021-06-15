class Page < ApplicationRecord
  include ActionView::Helpers::SanitizeHelper

  HTML_ATTRIBUTES = %w[href target src alt].freeze
  private_constant :HTML_ATTRIBUTES
  HTML_TAGS = %w[h2 h3 p strong em sub sup ul li ol a img br].freeze
  private_constant :HTML_TAGS
  INVALID_URLS = %w[admin auth css graphql login logout new robots sitemap].freeze
  private_constant :INVALID_URLS

  acts_as_list scope: :site, column: :main_menu_position, add_new_at: nil

  # relations
  belongs_to :site

  has_one(
    :privacy_policy_site,
    class_name: 'Site',
    foreign_key: 'privacy_policy_page_id',
    dependent: :nullify,
    inverse_of: 'privacy_policy_page'
  )

  # scopes
  scope(:non_private, -> { where(private: false) })
  scope(:ordered, -> { order(:name) })

  # before validations
  before_validation :clean_html_content

  TEXT_FIELDS = %i[html_content custom_html].freeze
  private_constant :TEXT_FIELDS
  strip_attributes except: TEXT_FIELDS, collapse_spaces: true, replace_newlines: true
  strip_attributes only: TEXT_FIELDS

  # validations
  validates(:site, presence: true)

  validates(
    :url,
    exclusion: { in: INVALID_URLS },
    length: { maximum: 64 },
    presence: true,
    uniqueness: { scope: :site_id }
  )

  validates(:name, length: { maximum: 64 }, presence: true)

  def clean_html_content
    self.html_content = sanitize(html_content, tags: HTML_TAGS, attributes: HTML_ATTRIBUTES)
  end

  def name=(value)
    self.url = value.delete("'").parameterize(separator: '_') if value
    super(value)
  end

  def to_param
    url_was
  end
end
