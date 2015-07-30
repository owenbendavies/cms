# == Schema Information
#
# Table name: pages
#
#  id            :integer          not null, primary key
#  site_id       :integer          not null
#  url           :string(64)       not null
#  name          :string(64)       not null
#  private       :boolean          default(FALSE), not null
#  contact_form  :boolean          default(FALSE), not null
#  html_content  :text
#  created_by_id :integer          not null
#  updated_by_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  fk__pages_created_by_id         (created_by_id)
#  fk__pages_site_id               (site_id)
#  fk__pages_updated_by_id         (updated_by_id)
#  index_pages_on_site_id_and_url  (site_id,url) UNIQUE
#
# Foreign Keys
#
#  fk_pages_created_by_id  (created_by_id => users.id)
#  fk_pages_site_id        (site_id => sites.id)
#  fk_pages_updated_by_id  (updated_by_id => users.id)
#

FactoryGirl.define do
  factory :page do
    site { Site.first || FactoryGirl.create(:site) }

    name { Faker::Name.name }
    html_content { "<p>#{Faker::Lorem.paragraph}</p>" }

    created_by { User.first || FactoryGirl.create(:admin) }
    updated_by { User.first || FactoryGirl.create(:admin) }

    factory :private_page do
      name 'Private'
      private true
    end
  end
end
