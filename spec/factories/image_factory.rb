# == Schema Information
#
# Table name: images
#
#  id            :integer          not null, primary key
#  site_id       :integer          not null
#  name          :string(64)       not null
#  filename      :string(36)
#  created_by_id :integer          not null
#  updated_by_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_images_on_created_by_id         (created_by_id)
#  index_images_on_site_id               (site_id)
#  index_images_on_site_id_and_filename  (site_id,filename) UNIQUE
#  index_images_on_site_id_and_name      (site_id,name) UNIQUE
#  index_images_on_updated_by_id         (updated_by_id)
#
# Foreign Keys
#
#  fk_rails_920d946580  (created_by_id => users.id)
#  fk_rails_df28ee77dc  (updated_by_id => users.id)
#  fk_rails_fc5c9b486e  (site_id => sites.id)
#

FactoryGirl.define do
  factory :image do
    site
    name { Faker::Name.name.gsub("'", '') }
    filename { "#{Digest::MD5.hexdigest(rand.to_s)}.jpg" }
    association :created_by, factory: :user
    association :updated_by, factory: :user
  end
end
