namespace :data do
  desc 'Migrate the data from CouchDB to SQL'
  task migrate: :environment do
    accounts = Account.all
    sites = Site.all
    pages = Page.all

    accounts.each do |account|
      puts "account: #{account.email}"

      data = account.to_hash
      data.delete '_id'
      data.delete '_rev'
      data.delete 'ruby_class'
      data.delete :sites

      db_account = DBAccount.find_or_initialize_by(email: account.email)
      db_account.attributes = data

      if db_account.changed?
        puts '  changed'
        db_account.save!
      end
    end

    sites.each do |site|
      puts "site: #{site.id} #{site.host}"

      data = site.to_hash
      data.delete '_attachments'
      data.delete '_id'
      data.delete '_rev'
      data.delete 'ruby_class'
      data.delete :css_filename
      data.delete :main_menu_page_ids

      account = accounts.find{|account| account.id == data.delete(:updated_by)}
      updated_by = DBAccount.find_by(email: account.email)

      data[:updated_by] = updated_by
      data[:created_by] = updated_by

      db_site = DBSite.find_or_initialize_by(host: site.host)
      db_site.attributes = data

      if db_site.changed?
        puts '  changed'
        db_site.save!
      end
    end

    accounts.each do |account|
      puts "account: #{account.email}"

      account_sites = account.sites.map do |site_host|
        DBSite.find_by(host: site_host)
      end

      db_account = DBAccount.find_by(email: account.email)
      db_account.sites = account_sites

      if db_account.changed?
        puts '  changed'
        db_account.save!
      end
    end

    pages.each do |page|
      puts "page: #{page.site_id} #{page.url}"

      data = page.to_hash
      data.delete '_id'
      data.delete '_rev'
      data.delete 'ruby_class'

      site = sites.find{|site| site.id == data.delete(:site_id) }
      data[:site] = DBSite.find_by(host: site.host)

      account = accounts.find{|account| account.id == data.delete(:created_by) }
      data[:created_by] = DBAccount.find_by(email: account.email)

      account = accounts.find{|account| account.id == data.delete(:updated_by) }
      data[:updated_by] = DBAccount.find_by(email: account.email)

      db_page = DBPage.find_or_initialize_by(site: data[:site], url: page.url)
      db_page.attributes = data

      if db_page.changed?
        puts '  changed'
        db_page.save!
      end
    end

    sites.each do |site|
      puts "site: #{site.id} #{site.host}"

      db_site = DBSite.find_by(host: site.host)

      main_menu_page_ids = site.main_menu_page_ids.map do |page_id|
        page = pages.find{|page| page.id == page_id}
        DBPage.find_by(site: db_site, url: page.url).id
      end

      db_site.main_menu_page_ids = main_menu_page_ids

      if db_site.changed?
        puts '  changed'
        db_site.save!
      end
    end

    Message.all.each do |message|
      puts "page: #{message.site_id} #{message.id}"

      data = message.to_hash
      data.delete '_id'
      data.delete '_rev'
      data.delete 'ruby_class'

      data[:email] = data.delete :email_address
      data[:phone] = data.delete :phone_number

      site = sites.find{|site| site.id == data.delete(:site_id) }
      data[:site] = DBSite.find_by(host: site.host)

      db_message = DBMessage.find_or_initialize_by(site: data[:site], created_at: message.created_at)
      db_message.attributes = data

      if db_message.changed?
        puts '  changed'
        db_message.save!
      end
    end

    Image.all.each do |image|
      puts "image: #{image.site_id} #{image.name}"

      data = image.to_hash
      data.delete '_id'
      data.delete '_rev'
      data.delete 'ruby_class'

      site = sites.find{|site| site.id == data.delete(:site_id) }
      data[:site] = DBSite.find_by(host: site.host)

      account = accounts.find{|account| account.id == data.delete(:created_by) }
      data[:created_by] = DBAccount.find_by(email: account.email)

      account = accounts.find{|account| account.id == data.delete(:updated_by) }
      data[:updated_by] = DBAccount.find_by(email: account.email)

      db_image = DBImage.find_or_initialize_by(site: data[:site], name: image.name)
      db_image.attributes = data

      if db_image.changed?
        puts '  changed'
        db_image.save!
      end
    end
  end
end
