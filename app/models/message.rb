class Message
  include CouchModel

  property :site_id, type: String
  property :subject, type: String
  property :name, type: String
  property :email_address, type: String
  property :phone_number, type: String
  property :delivered, type: :boolean, default: false
  property :message, type: String

  strip_attributes except: :message, collapse_spaces: true

  attr_accessor :do_not_fill_in
  attr_accessor :site

  set_callback :validate, :before do
    self.site_id = site.id if site
  end

  validates *property_names, no_html: true

  validates :site_id, presence: true

  validates :subject, presence: true

  validates :name, presence: true, length: {maximum: 64}

  validates :email_address,
    presence: true,
    length: {maximum: 64},
    email_format: true

  validates :phone_number, length: {maximum: 32}

  validates :message, presence: true, length: {maximum: 2048}

  validates :do_not_fill_in, length: {maximum: 0}

  validate do
    text = message.to_s.downcase

    [
      'facebook followers',
      'facebook likes',
      'facebook page likes',
      'facebook visitors',
      'search engine',
      'superbsocial',
    ].each do |spam_text|
      errors.add(:message, :spam) if text.include? spam_text
    end
  end

  view :by_site_id_and_created_at, key: [:site_id, :created_at]

  view :by_site_id_and_id, key: [:site_id, :_id]

  def self.find_by_site_and_id(site, id)
    CouchPotato.database.first(by_site_id_and_id(key: [site.id, id]))
  end

  def self.find_all_by_site(site)
    CouchPotato.database.view(
      by_site_id_and_created_at(startkey: [site.id], endkey: [site.id, {}])
    ).reverse
  end

  def deliver
    MessageMailer.new_message(self).deliver
    self.delivered = true
    self.save!
  end

  def error_messages
    self.errors.messages.delete_if do |_, message|
      message.blank?
    end
  end

  def save_spam_message
    if not valid?
      attributes = to_hash.except(:delivered, "ruby_class")
      spam_message = SpamMessage.new
      spam_message.do_not_fill_in = self.do_not_fill_in
      spam_message.error_messages = error_messages
      spam_message.update_attributes(attributes)
    end
  end
end
