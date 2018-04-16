# == Schema Information
#
# Table name: pages
#
#  id                 :integer          not null, primary key
#  site_id            :integer          not null
#  url                :string(64)       not null
#  name               :string(64)       not null
#  private            :boolean          default(FALSE), not null
#  contact_form       :boolean          default(FALSE), not null
#  html_content       :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  main_menu_position :integer
#  custom_html        :text
#  hidden             :boolean          default(FALSE), not null
#
# Indexes
#
#  index_pages_on_site_id                         (site_id)
#  index_pages_on_site_id_and_main_menu_position  (site_id,main_menu_position) UNIQUE
#  index_pages_on_site_id_and_url                 (site_id,url) UNIQUE
#
# Foreign Keys
#
#  fk_pages_site_id  (site_id => sites.id) ON DELETE => no_action ON UPDATE => no_action
#

FactoryBot.define do
  factory :page do
    site
    name { Faker::Name.name }
    html_content { "<p>#{Faker::Lorem.paragraph}</p>" }
    custom_html { "<p>#{Faker::Lorem.paragraph}</p>" }

    trait :hidden do
      hidden true
    end

    trait :private do
      private true
    end
  end
end
