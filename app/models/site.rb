# == Schema Information
#
# Table name: sites
#
#  id                     :integer          not null, primary key
#  host                   :string(64)       not null
#  name                   :string(64)       not null
#  google_analytics       :string(32)
#  charity_number         :string(32)
#  stylesheet_filename    :string(40)
#  sidebar_html_content   :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  main_menu_in_footer    :boolean          default(FALSE), not null
#  separate_header        :boolean          default(TRUE), not null
#  links                  :jsonb
#  privacy_policy_page_id :integer
#
# Indexes
#
#  index_sites_on_host                 (host) UNIQUE
#  index_sites_on_stylesheet_filename  (stylesheet_filename) UNIQUE
#
# Foreign Keys
#
#  fk__sites_privacy_policy_page_id  (privacy_policy_page_id => pages.id)
#

class Site < ApplicationRecord
  mount_uploader :stylesheet, StylesheetUploader, mount_on: :stylesheet_filename

  # relations
  has_many :images, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :pages, dependent: :destroy
  has_many :site_settings, dependent: :destroy
  has_many :users, through: :site_settings
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
    :stylesheet_filename,
    length: { allow_nil: true, maximum: 40 },
    uniqueness: { allow_nil: true }
  )

  validates(
    :links,
    json: { schema: Rails.root.join('config', 'json_schemas', 'site_links.json').to_s }
  )

  def address
    protocol = ENV['DISABLE_SSL'] ? 'http' : 'https'
    "#{protocol}://#{host}"
  end

  def css
    stylesheet.read
  end

  def css=(posted_css)
    posted_css.gsub!(/\t/, '  ')
    posted_css.gsub!(/ +\r\n/, "\r\n")

    self.stylesheet = StringUploader.new('stylesheet.css', posted_css)
  end

  def email
    "noreply@#{host.gsub(/^www\./, '')}"
  end
end
