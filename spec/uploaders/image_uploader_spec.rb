require 'rails_helper'

RSpec.describe ImageUploader do
  subject(:image_uploader) { described_class.new(Image.new(site: site)) }

  let(:site) { FactoryBot.build_stubbed(:site) }

  let(:expected_files) do
    [
      "images/#{image_uploader.uuid}/original.jpg",
      "images/#{image_uploader.uuid}/processed.jpg",
      "images/#{image_uploader.uuid}/span3.jpg",
      "images/#{image_uploader.uuid}/span4.jpg",
      "images/#{image_uploader.uuid}/span8.jpg",
      "images/#{image_uploader.uuid}/span12.jpg",
      "images/#{image_uploader.uuid}/thumbnail.jpg"
    ].sort
  end

  let(:uploaded_file_sizes) do
    file_sizes = expected_files.map do |filename|
      file = fog_directory.files.get(filename)
      image = MiniMagick::Image.read(file.body)
      [filename, "#{image[:width]}x#{image[:height]}"]
    end

    Hash[file_sizes]
  end

  describe '.store!' do
    context 'with non image file' do
      let(:upload) do
        File.open(Rails.root.join('spec/assets/bad.exe')) do |file|
          image_uploader.store! file
        end
      end

      it 'raise an exception' do
        expect { upload }.to raise_error(
          CarrierWave::IntegrityError,
          /.* "exe" files, allowed types: jpg, jpeg, png/
        )
      end
    end

    context 'with large file' do
      let(:expected_file_sizes) do
        {
          "images/#{image_uploader.uuid}/original.jpg" => '1296x968',
          "images/#{image_uploader.uuid}/processed.jpg" => '1296x968',
          "images/#{image_uploader.uuid}/span12.jpg" => '940x702',
          "images/#{image_uploader.uuid}/span8.jpg" => '620x463',
          "images/#{image_uploader.uuid}/span4.jpg" => '300x224',
          "images/#{image_uploader.uuid}/span3.jpg" => '220x164',
          "images/#{image_uploader.uuid}/thumbnail.jpg" => '200x200'
        }
      end

      before do
        File.open(Rails.root.join('spec/assets/test_image.jpg')) do |file|
          image_uploader.store! file
        end
      end

      it 'fits images to version sizes' do
        expect(uploaded_file_sizes).to eq expected_file_sizes
      end
    end

    context 'with small image' do
      let(:expected_file_sizes) do
        {
          "images/#{image_uploader.uuid}/original.jpg" => '80x80',
          "images/#{image_uploader.uuid}/processed.jpg" => '80x80',
          "images/#{image_uploader.uuid}/span12.jpg" => '80x80',
          "images/#{image_uploader.uuid}/span8.jpg" => '80x80',
          "images/#{image_uploader.uuid}/span4.jpg" => '80x80',
          "images/#{image_uploader.uuid}/span3.jpg" => '80x80',
          "images/#{image_uploader.uuid}/thumbnail.jpg" => '200x200'
        }
      end

      before do
        File.open(Rails.root.join('spec/assets/small.jpg')) do |file|
          image_uploader.store! file
        end
      end

      it 'does not enlarge image versions' do
        expect(uploaded_file_sizes).to eq expected_file_sizes
      end
    end

    context 'with file has exif data' do
      let(:uploaded_file_exif_data) do
        file_exif = expected_files.map do |filename|
          file = fog_directory.files.get(filename)
          image = MiniMagick::Image.read(file.body)
          [filename, image.exif]
        end

        Hash[file_exif]
      end

      let(:expected_file_exif_data) do
        {
          "images/#{image_uploader.uuid}/processed.jpg" => {},
          "images/#{image_uploader.uuid}/span12.jpg" => {},
          "images/#{image_uploader.uuid}/span8.jpg" => {},
          "images/#{image_uploader.uuid}/span4.jpg" => {},
          "images/#{image_uploader.uuid}/span3.jpg" => {},
          "images/#{image_uploader.uuid}/thumbnail.jpg" => {}
        }
      end

      before do
        File.open(Rails.root.join('spec/assets/test_image.jpg')) do |file|
          image_uploader.store! file
        end
      end

      it 'keeps exif data on origonal image' do
        exif = uploaded_file_exif_data.fetch("images/#{image_uploader.uuid}/original.jpg")
        expect(exif.fetch('GPSLatitude')).to eq '51/1, 30/1, 1220028377/53512833'
      end

      it 'removes exif data from image versions' do
        uploaded_file_exif_data.delete("images/#{image_uploader.uuid}/original.jpg")
        expect(uploaded_file_exif_data).to eq expected_file_exif_data
      end
    end

    context 'with filename extension that is capitals' do
      before do
        File.open(Rails.root.join('spec/assets/test_image_capital.JPG')) do |file|
          image_uploader.store! file
        end
      end

      it 'saves extension as downcase' do
        expect(uploaded_files).to eq expected_files
      end
    end

    context 'with .jpeg' do
      before do
        File.open(Rails.root.join('spec/assets/test_image.jpeg')) do |file|
          image_uploader.store! file
        end
      end

      it 'saves .jpeg as jpg' do
        expect(uploaded_files).to eq expected_files
      end
    end
  end
end
