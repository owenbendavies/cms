after 'sites', 'users' do
  User.where(sysadmin: true).find_each do |user|
    Site.find_each do |site|
      user.site_settings.where(site: site).first_or_create!(admin: true) do |_site_setting|
        STDOUT.puts "Creating SiteSetting for #{user.email} #{site.address}"
      end
    end
  end
end
