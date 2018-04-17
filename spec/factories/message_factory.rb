# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  site_id    :integer          not null
#  name       :string(64)       not null
#  email      :string(64)       not null
#  phone      :string(32)
#  message    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  uid        :string           not null
#
# Indexes
#
#  index_messages_on_created_at  (created_at)
#  index_messages_on_site_id     (site_id)
#  index_messages_on_uid         (uid) UNIQUE
#
# Foreign Keys
#
#  fk_messages_site_id  (site_id => sites.id)
#

FactoryBot.define do
  factory :message do
    site

    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { "+4478#{rand(100_000_000).to_s.ljust(8, '1')}" }
    message { Faker::Lorem.paragraph }
  end
end
