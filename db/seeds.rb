host = ENV['SEED_SITE_HOST']
host ||= "#{ENV.fetch('HEROKU_APP_NAME')}.herokuapp.com" if ENV['HEROKU_APP_NAME']

site = Site.where(host: host).first_or_create!(name: 'New Site') if host

email = ENV['SEED_USER_EMAIL']

if email
  user = User.where(email: email).first_or_create! do |new_user|
    password = SecureRandom.hex(16)

    new_user.sysadmin = true
    new_user.name = 'System Administrator'
    new_user.password = password
    new_user.password_confirmation = password
    new_user.skip_confirmation!
  end
end

if site && user
  user.site_settings.where(site: site).first_or_create! do |site_setting|
    site_setting.admin = true
  end
end
