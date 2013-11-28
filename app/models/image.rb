class Image
  include CouchModel

  property :site_id, type: String
  property :name, type: String
  property :created_by, type: String
  property :updated_by, type: String

  property :filename, type: String
  mount_uploader :file, ImageUploader, mount_on: :filename

  auto_strip_attributes *property_names, squish: true

  attr_accessor :site

  set_callback :validate, :before do
    self.site_id = site.id if site
  end

  validates *property_names, no_html: true
  validates :site_id, presence: true
  validates :name, presence: true, length: {maximum: 64}
  validates :created_by, presence: true
  validates :updated_by, presence: true

  view :by_site_id_and_name, key:[:site_id, :name]

  def self.find_all_by_site(site)
    CouchPotato.database.view(
      by_site_id_and_name(startkey: [site.id], endkey: [site.id, {}])
    ).each{|image| image.site = site}
  end

  def asset_host
    site.asset_host
  end

  def fog_directory
    site.fog_directory
  end
end
