FactoryBot.define do
  factory :user do
    id { SecureRandom.uuid }
    name { Faker::Name.name }
    email { Faker::Internet.email }

    groups do
      groups = [site].compact.map(&:host)
      groups << 'admin' if site_admin
      groups << 'sysadmin' if sysadmin
      groups
    end

    transient do
      site nil
      site_admin false
      sysadmin false
    end
  end
end
