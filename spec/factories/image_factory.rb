# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  site_id    :integer          not null
#  name       :string(64)       not null
#  filename   :string(36)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  fk__images_site_id                    (site_id)
#  index_images_on_site_id_and_filename  (site_id,filename) UNIQUE
#  index_images_on_site_id_and_name      (site_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_images_site_id  (site_id => sites.id)
#

FactoryGirl.define do
  factory :image do
    site { Site.first || FactoryGirl.create(:site) }

    name { Faker::Name.name.delete("'") }
    filename { "#{Digest::MD5.hexdigest(rand.to_s)}.jpg" }
  end
end
