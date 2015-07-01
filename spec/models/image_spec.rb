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
#  fk__images_created_by_id              (created_by_id)
#  fk__images_site_id                    (site_id)
#  fk__images_updated_by_id              (updated_by_id)
#  index_images_on_site_id_and_filename  (site_id,filename) UNIQUE
#  index_images_on_site_id_and_name      (site_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_images_created_by_id  (created_by_id => users.id)
#  fk_images_site_id        (site_id => sites.id)
#  fk_images_updated_by_id  (updated_by_id => users.id)
#

require 'rails_helper'

RSpec.describe Image do
  it { should belong_to(:site) }
  it { should belong_to(:created_by).class_name('User') }
  it { should belong_to(:updated_by).class_name('User') }

  it { should delegate_method(:store_dir).to(:site) }

  it 'is versioned', versioning: true do
    is_expected.to be_versioned
  end

  describe '#file', uploads: true do
    it 'saves an image' do
      image = FactoryGirl.create(
        :image,
        file: File.open(Rails.root.join('spec/assets/test_image.jpg'))
      )

      expect(image.file.url).to eq File.join(
        '/',
        Rails.application.secrets.uploads_store_dir,
        image.site.id.to_s,
        image.filename
      )

      expect(uploaded_files)
        .to include "#{image.site.id}/a7a78bb78134027c41d2eedc6efd4edb.jpg"
    end
  end

  it { is_expected.to strip_attribute(:name).collapse_spaces }

  describe 'validate' do
    subject { FactoryGirl.build(:image) }

    it { should validate_presence_of(:site) }

    it { should validate_presence_of(:name) }

    it { should validate_uniqueness_of(:name).scoped_to(:site_id) }

    it { should validate_length_of(:name).is_at_most(64) }

    it { should validate_uniqueness_of(:filename).scoped_to(:site_id) }

    it { should validate_presence_of(:created_by) }

    it { should validate_presence_of(:updated_by) }
  end
end
