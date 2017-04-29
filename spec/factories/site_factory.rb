# == Schema Information
#
# Table name: sites
#
#  id                   :integer          not null, primary key
#  host                 :string(64)       not null
#  name                 :string(64)       not null
#  sub_title            :string(64)
#  copyright            :string(64)
#  google_analytics     :string(32)
#  charity_number       :string(32)
#  stylesheet_filename  :string(40)
#  sidebar_html_content :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  main_menu_in_footer  :boolean          default(FALSE), not null
#  separate_header      :boolean          default(TRUE), not null
#
# Indexes
#
#  index_sites_on_host                 (host) UNIQUE
#  index_sites_on_stylesheet_filename  (stylesheet_filename) UNIQUE
#

FactoryGirl.define do
  factory :site do
    host { Faker::Internet.domain_name }
    name { Faker::Company.name.delete("'") }
  end
end
