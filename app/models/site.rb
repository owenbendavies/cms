# == Schema Information
#
# Table name: sites
#
#  id                     :integer          not null, primary key
#  host                   :string(64)       not null
#  name                   :string(64)       not null
#  google_analytics       :string(32)
#  charity_number         :string(32)
#  sidebar_html_content   :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  main_menu_in_footer    :boolean          default(FALSE), not null
#  separate_header        :boolean          default(TRUE), not null
#  links                  :jsonb
#  privacy_policy_page_id :integer
#  uid                    :string           not null
#
# Indexes
#
#  index_sites_on_host  (host) UNIQUE
#  index_sites_on_uid   (uid) UNIQUE
#
# Foreign Keys
#
#  fk__sites_privacy_policy_page_id  (privacy_policy_page_id => pages.id)
#

class Site < ApplicationRecord
  include DefaultUid

  # relations
  has_many :images, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :pages, dependent: :destroy
  has_many :site_settings, dependent: :destroy
  has_many :users, through: :site_settings
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
end
