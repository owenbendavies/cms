host = ENV['SEED_SITE_HOST']
host ||= "#{ENV.fetch('HEROKU_APP_NAME')}.herokuapp.com" if ENV['HEROKU_APP_NAME']

raise ArgumentError, 'SEED_SITE_HOST or HEROKU_APP_NAME environment variable not set' unless host

Site.where(host: host).first_or_create!(name: 'New Site') do |site|
  STDOUT.puts "Creating Site #{site.address}"
end
