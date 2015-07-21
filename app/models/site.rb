# == Schema Information
#
# Table name: sites
#
#  id                   :integer          not null, primary key
#  host                 :string(64)       not null
#  name                 :string(64)       not null
#  sub_title            :string(64)
#  layout               :string(32)       default("one_column"), not null
#  main_menu_page_ids   :text
#  copyright            :string(64)
#  google_analytics     :string(32)
#  charity_number       :string(32)
#  stylesheet_filename  :string(36)
#  sidebar_html_content :text
#  created_by_id        :integer          not null
#  updated_by_id        :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  main_menu_in_footer  :boolean          default(FALSE), not null
#  separate_header      :boolean          default(TRUE), not null
#  facebook             :string(64)
#  twitter              :string(15)
#  linkedin             :string(32)
#  github               :string(32)
#  youtube              :string(32)
#
# Indexes
#
#  fk__sites_created_by_id  (created_by_id)
#  fk__sites_updated_by_id  (updated_by_id)
#  index_sites_on_host      (host) UNIQUE
#
# Foreign Keys
#
#  fk_sites_created_by_id  (created_by_id => users.id)
#  fk_sites_updated_by_id  (updated_by_id => users.id)
#

class Site < ActiveRecord::Base
  LAYOUTS = %w(one_column right_sidebar small_right_sidebar)

  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  has_many :site_settings
  has_many :users, -> { order :email }, through: :site_settings

  has_many :images, -> { order :name }, dependent: :destroy
  has_many :messages, -> { order 'created_at desc' }, dependent: :destroy
  has_many :pages, -> { order :name }, dependent: :destroy

  has_paper_trail

  serialize :main_menu_page_ids, Array

  mount_uploader :stylesheet, StylesheetUploader, mount_on: :stylesheet_filename

  strip_attributes except: :sidebar_html_content, collapse_spaces: true

  validates :name, length: { minimum: 3 }
  validates :sub_title, length: { allow_nil: true, minimum: 3 }
  validates :layout, inclusion: { in: LAYOUTS }

  validates :google_analytics, format: {
    with: /\AUA-[0-9]+-[0-9]{1,2}\z/,
    allow_blank: true
  }

  def all_users
    User.admin + users
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

  def main_menu_pages
    pages = Page.find(main_menu_page_ids)

    main_menu_page_ids.map do |id|
      pages.find { |page| page.id == id }
    end
  end

  def store_dir
    [Rails.application.secrets.uploads_store_dir, id].compact.join('/')
  end

  def social_networks?
    !(!facebook && !twitter && !youtube && !linkedin && !github)
  end
end
