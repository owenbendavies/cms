# == Schema Information
#
# Table name: sites
#
#  id                     :integer          not null, primary key
#  host                   :string(64)       not null
#  name                   :string(64)       not null
#  google_analytics       :string(32)
#  charity_number         :string(32)
#  sidebar_html_content   :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  main_menu_in_footer    :boolean          default(FALSE), not null
#  separate_header        :boolean          default(TRUE), not null
#  links                  :jsonb
#  privacy_policy_page_id :integer
#  uid                    :string           not null
#
# Indexes
#
#  index_sites_on_host  (host) UNIQUE
#  index_sites_on_uid   (uid) UNIQUE
#
# Foreign Keys
#
#  fk__sites_privacy_policy_page_id  (privacy_policy_page_id => pages.id)
#

FactoryBot.define do
  factory :site do
    host { Faker::Internet.domain_name }
    name { Faker::Company.name.delete("'") }

    trait :with_links do
      links do
        [
          {
            'name' => Faker::Name.name,
            'url' =>  Faker::Internet.url,
            'icon' => 'fas fa-facebook fa-fw'
          }
        ]
      end
    end

    trait :with_privacy_policy do
      association :privacy_policy_page, factory: :page
    end
  end
end
