require 'rails_helper'

RSpec.describe ImageUploader do
  subject(:image_uploader) { described_class.new(Image.new(site: site)) }

  let(:site) { FactoryGirl.create(:site) }

  let(:expected_files) do
    [
      "images/#{image_uploader.uuid}/original.jpg",
      "images/#{image_uploader.uuid}/processed.jpg",
      "images/#{image_uploader.uuid}/span3.jpg",
      "images/#{image_uploader.uuid}/span4.jpg",
      "images/#{image_uploader.uuid}/span8.jpg",
      "images/#{image_uploader.uuid}/span12.jpg"
    ].sort
  end

  describe '.store!' do
    context 'with a non image file' do
      it 'raise an exception' do
        expect { image_uploader.store! StringUploader.new('stylesheet.exe', 'asd') }
          .to raise_error(
            CarrierWave::IntegrityError,
            /.* "exe" files, allowed types: jpg, jpeg, png/
          )
      end
    end

    context 'with a file' do
      before do
        File.open(Rails.root.join('spec', 'assets', 'test_image.jpg')) do |file|
          image_uploader.store! file
        end
      end

      it 'stores file with filename which is uuid' do
        expect(image_uploader.uuid).to match(/\A[0-9a-f-]+\z/)
      end

      it 'creates expected files' do
        expect(uploaded_files).to eq expected_files
      end

      it 'creates span3 image' do
        expect(image_dimension(image_uploader.span3)).to eq '220x164'
      end

      it 'creates span4 image' do
        expect(image_dimension(image_uploader.span4)).to eq '300x224'
      end

      it 'creates span8 image' do
        expect(image_dimension(image_uploader.span8)).to eq '620x463'
      end

      it 'creates span12 image' do
        expect(image_dimension(image_uploader.span12)).to eq '940x702'
      end
    end

    context 'file with exif data' do
      before do
        File.open(Rails.root.join('spec', 'assets', 'test_image.jpg')) do |file|
          image_uploader.store! file
        end
      end

      it 'keeps exif data on origonal image' do
        data = remote_image(image_uploader).exif['GPSLatitude']
        expect(data).to eq '51/1, 30/1, 1220028377/53512833'
      end

      it 'removes exif data from processed image' do
        expect(remote_image(image_uploader.processed).exif.keys).to be_empty
      end

      it 'removes exif data from span3 image' do
        expect(remote_image(image_uploader.span3).exif.keys).to be_empty
      end

      it 'removes exif data from span4 image' do
        expect(remote_image(image_uploader.span4).exif.keys).to be_empty
      end

      it 'removes exif data from span8 image' do
        expect(remote_image(image_uploader.span8).exif.keys).to be_empty
      end

      it 'removes exif data from span12 image' do
        expect(remote_image(image_uploader.span12).exif.keys).to be_empty
      end
    end

    context 'with a small image' do
      before do
        File.open(Rails.root.join('spec', 'assets', 'small.jpg')) do |file|
          image_uploader.store! file
        end
      end

      it 'does not enlarge span3 image' do
        expect(image_dimension(image_uploader.span3)).to eq '80x80'
      end

      it 'does not enlarge span4 image' do
        expect(image_dimension(image_uploader.span4)).to eq '80x80'
      end

      it 'does not enlarge span8 image' do
        expect(image_dimension(image_uploader.span8)).to eq '80x80'
      end

      it 'does not enlarge span12 image' do
        expect(image_dimension(image_uploader.span12)).to eq '80x80'
      end
    end

    context 'with a filename extension that is capitals' do
      before do
        File.open(Rails.root.join('spec', 'assets', 'test_image_capital.JPG')) do |file|
          image_uploader.store! file
        end
      end

      it 'saves extension as downcase' do
        expect(uploaded_files).to eq expected_files
      end
    end

    context 'with a .jpeg' do
      before do
        File.open(Rails.root.join('spec', 'assets', 'test_image.jpeg')) do |file|
          image_uploader.store! file
        end
      end

      it 'saves .jpeg as jpg' do
        expect(uploaded_files).to eq expected_files
      end
    end
  end
end
