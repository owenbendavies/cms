# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  site_id    :integer          not null
#  name       :string(64)       not null
#  filename   :string(40)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  fk__images_site_id                (site_id)
#  index_images_on_filename          (filename) UNIQUE
#  index_images_on_site_id_and_name  (site_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_images_site_id  (site_id => sites.id) ON DELETE => no_action ON UPDATE => no_action
#

require 'rails_helper'

RSpec.describe Image do
  describe '#file' do
    it 'saves an image' do
      image = described_class.new
      image.site = FactoryGirl.create(:site)
      image.name = Faker::Name.name.delete("'")

      File.open(Rails.root.join('spec/assets/test_image.jpg')) do |file|
        image.file = file
      end

      image.save!

      expect(image.filename).to match(/\A[0-9a-f-]+\.jpg/)

      uuid = File.basename(image.filename, '.jpg')

      expect(image.file.url).to eq File.join(
        'https://obduk-cms-test.s3-eu-east-1.amazonaws.com',
        'images',
        uuid,
        'original.jpg'
      )

      expect(uploaded_files).to include "images/#{uuid}/original.jpg"
    end

    it 'recreates versions' do
      image = described_class.new
      image.site = FactoryGirl.create(:site)
      image.name = Faker::Name.name.delete("'")

      File.open(Rails.root.join('spec/assets/test_image.jpg')) do |file|
        image.file = file
      end

      image.save!

      files = uploaded_files

      described_class.find(image.id).file.recreate_versions!

      expect(uploaded_files).to eq files
    end
  end

  describe '.ordered' do
    it 'returns ordered by name' do
      image_c = FactoryGirl.create(:image, name: 'image C')
      image_a = FactoryGirl.create(:image, name: 'image A')
      image_b = FactoryGirl.create(:image, name: 'image B')

      expect(described_class.ordered).to eq [image_a, image_b, image_c]
    end
  end

  it { is_expected.to strip_attribute(:name).collapse_spaces }

  describe '#valid?' do
    it 'validates database schema' do
      is_expected.to validate_presence_of(:name)
    end
  end
end
