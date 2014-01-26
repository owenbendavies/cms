class Page
  include CouchModel

  INVALID_URLS = %w(account health login logout new robots site sitemap)

  property :site_id, type: String
  property :url, type: String
  property :name, type: String
  property :private, type: :boolean, default: false
  property :bottom_section, type: String
  property :created_by, type: String
  property :updated_by, type: String

  auto_strip_attributes *property_names, squish: true

  validates *property_names, no_html: true

  property :html_content, type: String

  set_callback :save, :before do
    self.url = new_url
  end

  validates :site_id,
    presence: true

  validates :name,
    presence: true,
    length: {maximum: 64}

  validates :bottom_section,
    inclusion: {in: %w(contact_form), allow_nil: true}

  validates :created_by,
    presence: true

  validates :updated_by,
    presence: true

  validate do
    errors.add(:name) if new_url.blank? or INVALID_URLS.include? new_url
  end

  view :by_site_id_and_url, key: [:site_id, :url]

  view :link_by_site_id_and_url,
    key: [:site_id, :url],
    type: :properties,
    properties: [:url, :name, :private, :updated_at, :updated_by]

  alias_method :to_param, :url

  def self.find_by_site_and_url(site, url)
    CouchPotato.database.first(by_site_id_and_url(key: [site.id, url]))
  end

  def self.find_all_links_by_site(site)
    CouchPotato.database.view(
      link_by_site_id_and_url(startkey: [site.id], endkey: [site.id, {}])
    )
  end

  def new_url
    name.to_s.parameterize('_')
  end
end
