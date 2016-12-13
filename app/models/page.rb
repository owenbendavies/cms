# == Schema Information
#
# Table name: pages
#
#  id                 :integer          not null, primary key
#  site_id            :integer          not null
#  url                :string(64)       not null
#  name               :string(64)       not null
#  private            :boolean          default(FALSE), not null
#  contact_form       :boolean          default(FALSE), not null
#  html_content       :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  main_menu_position :integer
#  custom_html        :text
#  hidden             :boolean          default(FALSE), not null
#
# Indexes
#
#  fk__pages_site_id                              (site_id)
#  index_pages_on_site_id_and_main_menu_position  (site_id,main_menu_position) UNIQUE
#  index_pages_on_site_id_and_url                 (site_id,url) UNIQUE
#
# Foreign Keys
#
#  fk_pages_site_id  (site_id => sites.id) ON DELETE => no_action ON UPDATE => no_action
#

class Page < ApplicationRecord
  include ActionView::Helpers::SanitizeHelper
  HTML_TAGS = %w(h2 h3 p strong em sub sup ul li ol a img br).freeze
  HTML_ATTRIBUTES = %w(href target class src alt).freeze

  INVALID_URLS = %w(login logout new robots site sitemap system user).freeze

  acts_as_list scope: :site, column: :main_menu_position, add_new_at: nil

  before_validation :clean_html_content

  schema_validations

  scope :ordered, -> { order(:name) }
  scope :visible, -> { where(hidden: false).where(private: false) }

  strip_attributes(
    except: [:html_content, :custom_html],
    collapse_spaces: true,
    replace_newlines: true
  )

  validates :url, exclusion: { in: INVALID_URLS }

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
