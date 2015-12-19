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
#  fk__images_site_id                    (site_id)
#  index_images_on_site_id_and_filename  (site_id,filename) UNIQUE
#  index_images_on_site_id_and_name      (site_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_images_site_id  (site_id => sites.id)
#

require 'rails_helper'

RSpec.describe Image, type: :model do
  it { should belong_to(:site) }

  it { should delegate_method(:store_dir).to(:site) }

  it 'is versioned', versioning: true do
    is_expected.to be_versioned
  end

  describe '#file' do
    it 'saves an image' do
      uuid = SecureRandom.uuid
      allow(SecureRandom).to receive(:uuid).and_return(uuid)

      image = described_class.new
      image.site = FactoryGirl.create(:site)
      image.name = Faker::Name.name.delete("'")

      File.open(Rails.root.join('spec/assets/test_image.jpg')) do |file|
        image.file = file
      end

      image.save!

      expect(image.file.url).to eq File.join(
        'https://obduk-cms-test.s3-eu-west-1.amazonaws.com',
        image.site.id.to_s,
        image.filename
      )

      expect(uploaded_files).to include "#{image.site.id}/#{uuid}.jpg"
    end
  end

  it { is_expected.to strip_attribute(:name).collapse_spaces }

  describe 'validate' do
    subject { FactoryGirl.build(:image) }

    it { should validate_presence_of(:site) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:site_id) }
    it { should validate_length_of(:name).is_at_most(64) }
  end
end
