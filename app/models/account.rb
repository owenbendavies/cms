class Account
  include CouchModel
  include Gravtastic
  extend ActiveModel::SecurePassword::ClassMethods

  gravtastic secure: false, default: 'mm', size: 24

  property :email, type: String
  property :sites, type: Array, default: []

  auto_strip_attributes *property_names, squish: true
  validates *property_names, no_html: true

  property :password_digest
  has_secure_password

  validates :password, length: {minimum: 8, maximum: 64, allow_blank: true}
  validates :email, presence: true, length: {maximum: 64}, email: true

  view :by_site_host_and_email,
    type: :custom,
    include_docs: true,
    map: <<EOF
function(doc) {
  if(doc.ruby_class && doc.ruby_class == 'Account') {
    for(var i in doc.sites) {
      emit([doc.sites[i], doc.email], 1);
    }
  }
}
EOF

  view :emails_by_site,
    type: :raw,
    results_filter: lambda {|results|
      results['rows'].map{|row| row['value']['email']}
    },
    map: <<EOF
function(doc) {
  if(doc.ruby_class && doc.ruby_class == 'Account') {
    for(var i in doc.sites) {
      emit(doc.sites[i], {'email': doc.email});
    }
  }
}
EOF

  def self.find_and_authenticate(email, password, site)
    account = CouchPotato.database.first(
      Account.by_site_host_and_email(key: [site.host, email.squish.downcase])
    )

    return unless account
    return unless account.authenticate(password.squish)
    account
  end

  def self.find_emails_by_site(site)
    CouchPotato.database.view(emails_by_site(key: site.host)).sort
  end
end
