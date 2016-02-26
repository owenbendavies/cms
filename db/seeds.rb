host = Rails.application.secrets.host
site = Site.where(host: host).first_or_create!(name: 'New Site')

email = Rails.application.secrets.sysadmin_email

user = User.where(email: email).first_or_create! do |new_user|
  password = SecureRandom.hex(16)

  new_user.sysadmin = true
  new_user.name = 'System Administrator'
  new_user.password = password
  new_user.password_confirmation = password
  new_user.skip_confirmation!
end

user.site_settings.where(site: site).first_or_create! do |site_setting|
  site_setting.admin = true
end
