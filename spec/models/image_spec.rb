require 'rails_helper'

RSpec.describe Image do
  it_behaves_like 'model with versioning'

  describe '#file' do
    let(:image) { FactoryBot.build(:image, filename: nil) }

    let(:uuid) { File.basename(image.filename, '.jpg') }

    let(:filename) do
      File.join(
        ENV.fetch('AWS_S3_ASSET_HOST'),
        'images',
        uuid,
        'original.jpg'
      )
    end

    before do
      File.open(Rails.root.join('spec/assets/test_image.jpg')) do |file|
        image.file = file
      end

      image.save!
    end

    it 'saves an image' do
      expect(uploaded_files).to include "images/#{uuid}/original.jpg"
    end

    it 'saves filename as uuid' do
      expect(image.filename).to match(/\A[0-9a-f-]+\.jpg/)
    end

    it 'stores filename as url' do
      expect(image.file.public_url).to eq filename
    end

    it 'recreates versions' do
      files = uploaded_files

      described_class.find(image.id).file.recreate_versions!

      expect(uploaded_files).to eq files
    end
  end

  describe 'relations' do
    it { is_expected.to belong_to(:site) }
  end

  describe 'scopes' do
    describe '.ordered' do
      it 'returns ordered by name' do
        image_c = FactoryBot.create(:image, name: 'image C')
        image_a = FactoryBot.create(:image, name: 'image A')
        image_b = FactoryBot.create(:image, name: 'image B')

        expect(described_class.ordered).to eq [image_a, image_b, image_c]
      end
    end
  end

  describe 'before validations' do
    it { is_expected.to strip_attribute(:name).collapse_spaces }
  end

  describe 'validations' do
    subject { FactoryBot.build(:image) }

    it { is_expected.to validate_presence_of(:site) }

    it { is_expected.to validate_length_of(:name).is_at_most(64) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:site_id) }

    it { is_expected.to validate_uniqueness_of(:filename) }
  end
end
