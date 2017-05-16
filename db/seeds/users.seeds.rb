email = ENV['SEED_USER_EMAIL']

raise ArgumentError, 'SEED_USER_EMAIL environment variable not set' unless email

User.where(email: email).first_or_create! do |new_user|
  STDOUT.puts "Creating User #{email}"

  password = SecureRandom.hex(16)

  new_user.sysadmin = true
  new_user.name = 'System Administrator'
  new_user.password = password
  new_user.password_confirmation = password
  new_user.skip_confirmation!
end
