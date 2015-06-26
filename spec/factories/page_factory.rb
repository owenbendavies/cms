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
#  index_pages_on_created_by_id    (created_by_id)
#  index_pages_on_site_id          (site_id)
#  index_pages_on_site_id_and_url  (site_id,url) UNIQUE
#  index_pages_on_updated_by_id    (updated_by_id)
#
# Foreign Keys
#
#  fk_rails_06bf42f87e  (updated_by_id => users.id)
#  fk_rails_a8ad97ecff  (site_id => sites.id)
#  fk_rails_af73c24fa7  (created_by_id => users.id)
#

FactoryGirl.define do
  factory :page do
    site
    name { Faker::Name.name }
    html_content { "<p>#{Faker::Lorem.paragraph}</p>" }
    association :created_by, factory: :user
    association :updated_by, factory: :user

    factory :private_page do
      name 'Private'
      private true
    end
  end
end
