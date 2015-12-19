# == Schema Information
#
# Table name: sites
#
#  id                   :integer          not null, primary key
#  host                 :string(64)       not null
#  name                 :string(64)       not null
#  sub_title            :string(64)
#  layout               :string(32)       default("one_column"), not null
#  copyright            :string(64)
#  google_analytics     :string(32)
#  charity_number       :string(32)
#  stylesheet_filename  :string(40)
#  sidebar_html_content :text
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
#  index_sites_on_host  (host) UNIQUE
#

class Site < ActiveRecord::Base
  LAYOUTS = %w(one_column right_sidebar small_right_sidebar)

  has_many :images, -> { order :name }, dependent: :destroy
  has_many :messages, -> { order 'created_at desc' }, dependent: :destroy
  has_many :pages, -> { order :name }, dependent: :destroy
  has_many :site_settings, dependent: :destroy
  has_many :users, -> { order :email }, through: :site_settings
  has_many :main_menu_pages, -> { in_list.order(:main_menu_position) }, class_name: 'Page'

  has_paper_trail

  mount_uploader :stylesheet, StylesheetUploader, mount_on: :stylesheet_filename

  strip_attributes except: :sidebar_html_content, collapse_spaces: true

  validates :name, length: { minimum: 3 }
  validates :sub_title, length: { allow_nil: true, minimum: 3 }
  validates :layout, inclusion: { in: LAYOUTS }
  validates :google_analytics, format: { with: /\AUA-[0-9]+-[0-9]{1,2}\z/, allow_blank: true }

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

  def store_dir
    id.to_s
  end

  def social_networks?
    !(!facebook && !twitter && !youtube && !linkedin && !github)
  end
end
