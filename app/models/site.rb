class Site
  include CouchModel

  LAYOUTS = [
    'one_column',
    'right_sidebar',
    'small_right_sidebar',
    'fluid'
  ]

  property :host, type: String
  property :name, type: String
  property :sub_title, type: String
  property :layout, type: String, default: 'one_column'
  property :asset_host, type: String
  property :main_menu, type: Array, default: []
  property :copyright, type: String
  property :google_analytics, type: String
  property :charity_number, type: String
  property :updated_by, type: String

  property :stylesheet_filename, type: String
  mount_uploader :stylesheet, StylesheetUploader, mount_on: :stylesheet_filename

  property :header_image_filename, type: String
  mount_uploader :header_image, ImageUploader, mount_on: :header_image_filename

  auto_strip_attributes *property_names, squish: true
  validates *property_names, no_html: true

  property :sidebar_html_content, type: String

  validates :host, presence: true
  validates :name, presence: true, length: {maximum: 64}
  validates :sub_title, length: {maximum: 64}
  validates :layout, inclusion: {in: LAYOUTS}
  validates :copyright, length: {maximum: 64}

  validates :google_analytics, format: {
    with: /\AUA-[0-9]+-[0-9]{1,2}\z/,
    allow_blank: true
  }

  validates :updated_by, presence: true

  view :by_host, key: :host

  def self.find_by_host!(host)
    CouchPotato.database.first!(by_host(key: host.downcase))
  end

  def fog_directory
    application_name = Rails.application.class.parent_name.downcase
    [Rails.env, application_name, host.parameterize('_')].join('_')
  end

  def css
    stylesheet.read
  end

  def css=(posted_css)
    posted_css.gsub!(/\t/, '  ')
    posted_css.gsub!(/ +\r\n/, "\r\n")

    self.stylesheet = StringUploader.new("stylesheet.css", posted_css)
  end
end
