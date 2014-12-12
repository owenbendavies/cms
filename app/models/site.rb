# == Schema Information
#
# Table name: sites
#
#  id                    :integer          not null, primary key
#  host                  :string(64)       not null
#  name                  :string(64)       not null
#  sub_title             :string(64)
#  layout                :string(255)      default("one_column")
#  main_menu_page_ids    :string(255)
#  copyright             :string(64)
#  google_analytics      :string(255)
#  charity_number        :string(255)
#  stylesheet_filename   :string(36)
#  header_image_filename :string(36)
#  sidebar_html_content  :text
#  created_by_id         :integer          not null
#  updated_by_id         :integer          not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Site < ActiveRecord::Base
  LAYOUTS = %w(one_column right_sidebar small_right_sidebar)

  belongs_to :created_by, class_name: 'Account'
  belongs_to :updated_by, class_name: 'Account'

  has_and_belongs_to_many :accounts

  has_many :images, -> { order :name }
  has_many :messages, -> { order created_at: :desc }
  has_many :pages, -> { order :name }

  serialize :main_menu_page_ids, Array

  mount_uploader :stylesheet, StylesheetUploader, mount_on: :stylesheet_filename
  mount_uploader :header_image, ImageUploader, mount_on: :header_image_filename

  strip_attributes except: :sidebar_html_content, collapse_spaces: true

  validates *(attribute_names - ['sidebar_html_content']), no_html: true
  validates :host, presence: true, length: { maximum: 64 }
  validates :name, presence: true, length: { maximum: 64 }
  validates :sub_title, length: { maximum: 64 }
  validates :layout, inclusion: { in: LAYOUTS }
  validates :copyright, length: { maximum: 64 }

  validates :google_analytics, format: {
    with: /\AUA-[0-9]+-[0-9]{1,2}\z/,
    allow_blank: true
  }

  validates :created_by, presence: true
  validates :updated_by, presence: true

  def css
    stylesheet.read
  end

  def css=(posted_css)
    posted_css.gsub!(/\t/, '  ')
    posted_css.gsub!(/ +\r\n/, "\r\n")

    self.stylesheet = StringUploader.new('stylesheet.css', posted_css)
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
end
