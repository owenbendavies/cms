class SpamMessage
  include CouchModel

  property :site_id, type: String
  property :subject, type: String
  property :name, type: String
  property :email_address, type: String
  property :phone_number, type: String
  property :message, type: String
end
