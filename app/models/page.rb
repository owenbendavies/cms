class Page < ApplicationRecord
  include ActionView::Helpers::SanitizeHelper

  HTML_ATTRIBUTES = %w[href target class src alt].freeze
  HTML_TAGS = %w[h2 h3 p strong em sub sup ul li ol a img br].freeze
  INVALID_URLS = %w[admin auth css graphql login logout new robots sitemap].freeze

  acts_as_list scope: :site, column: :main_menu_position, add_new_at: nil

  # relations
  belongs_to :site

  # scopes
  scope(:ordered, -> { order(:name) })
  scope(:visible, -> { where(hidden: false).where(private: false) })

  # before validations
  before_validation :clean_html_content

  strip_attributes(
    except: %i[html_content custom_html],
    collapse_spaces: true,
    replace_newlines: true
  )

  # validations
  validates(
    :site,
    presence: true
  )

  validates(
    :url,
    exclusion: { in: INVALID_URLS },
    length: { maximum: 64 },
    presence: true,
    uniqueness: { scope: :site_id }
  )

  validates(
    :name,
    length: { maximum: 64 },
    presence: true
  )

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
