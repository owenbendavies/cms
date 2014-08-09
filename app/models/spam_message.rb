class SpamMessage
  include CouchModel

  property :site_id, type: String
  property :subject, type: String
  property :name, type: String
  property :email_address, type: String
  property :phone_number, type: String
  property :message, type: String
  property :do_not_fill_in, type: String
  property :error_messages, type: Hash
end
