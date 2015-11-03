host = Rails.application.secrets.host
site = Site.where(host: host).first_or_create!(name: 'New Site')

email = Rails.application.secrets.admin_email

user = User.where(email: email).first_or_create! do |new_user|
  password = SecureRandom.hex(16)

  new_user.admin = true
  new_user.name = 'Admin User'
  new_user.password = password
  new_user.password_confirmation = password
  new_user.skip_confirmation!
end

user.site_settings.where(site: site).first_or_create!
