require 'rails_helper'

RSpec.describe ImageUploader do
  subject { described_class.new(Image.new(site: site)) }

  let(:site) { FactoryGirl.create(:site) }

  describe '.store!' do
    context 'with a non image file' do
      it 'raise an exception' do
        expect { subject.store! StringUploader.new('stylesheet.exe', 'asd') }
          .to raise_error(
            CarrierWave::IntegrityError,
            /.* "exe" files, allowed types: jpg, jpeg, png/
          )
      end
    end

    context 'with a file' do
      before do
        File.open(Rails.root.join('spec/assets/test_image.jpg')) do |file|
          subject.store! file
        end
      end

      it 'stores file with filename which is uuid' do
        expect(subject.uuid).to match(/\A[0-9a-f-]+\z/)

        expect(uploaded_files).to eq [
          "images/#{subject.uuid}/original.jpg",
          "images/#{subject.uuid}/processed.jpg",
          "images/#{subject.uuid}/span3.jpg",
          "images/#{subject.uuid}/span4.jpg",
          "images/#{subject.uuid}/span8.jpg",
          "images/#{subject.uuid}/span12.jpg"
        ].sort

        image = remote_image(subject.span3)
        expect(image[:width]).to eq 220
        expect(image[:height]).to eq 164

        image = remote_image(subject.span4)
        expect(image[:width]).to eq 300
        expect(image[:height]).to eq 224

        image = remote_image(subject.span8)
        expect(image[:width]).to eq 620
        expect(image[:height]).to eq 463

        image = remote_image(subject.span12)
        expect(image[:width]).to eq 940
        expect(image[:height]).to eq 702
      end
    end

    context 'file with exif data' do
      before do
        File.open(Rails.root.join('spec/assets/test_image.jpg')) do |file|
          subject.store! file
        end
      end

      it 'removes exif data' do
        expect(remote_image(subject).exif['GPSLatitude']).to eq '51/1, 30/1, 1220028377/53512833'

        expect(remote_image(subject.processed).exif.keys).to eq []
        expect(remote_image(subject.span3).exif.keys).to eq []
        expect(remote_image(subject.span4).exif.keys).to eq []
        expect(remote_image(subject.span8).exif.keys).to eq []
        expect(remote_image(subject.span12).exif.keys).to eq []
      end
    end

    context 'with a small image' do
      before do
        File.open(Rails.root.join('spec/assets/small.jpg')) do |file|
          subject.store! file
        end
      end

      it 'does not enlarge image' do
        image = remote_image(subject.span3)
        expect(image[:width]).to eq 80
        expect(image[:height]).to eq 80

        image = remote_image(subject.span4)
        expect(image[:width]).to eq 80
        expect(image[:height]).to eq 80

        image = remote_image(subject.span8)
        expect(image[:width]).to eq 80
        expect(image[:height]).to eq 80

        image = remote_image(subject.span12)
        expect(image[:width]).to eq 80
        expect(image[:height]).to eq 80
      end
    end

    context 'with a filename extension that is capitals' do
      before do
        File.open(Rails.root.join('spec/assets/test_image_capital.JPG')) do |file|
          subject.store! file
        end
      end

      it 'saves extension as downcase' do
        expect(uploaded_files).to eq [
          "images/#{subject.uuid}/original.jpg",
          "images/#{subject.uuid}/processed.jpg",
          "images/#{subject.uuid}/span3.jpg",
          "images/#{subject.uuid}/span4.jpg",
          "images/#{subject.uuid}/span8.jpg",
          "images/#{subject.uuid}/span12.jpg"
        ].sort
      end
    end

    context 'with a .jpeg' do
      before do
        File.open(Rails.root.join('spec/assets/test_image.jpeg')) do |file|
          subject.store! file
        end
      end

      it 'saves .jpeg as jpg' do
        expect(uploaded_files).to eq [
          "images/#{subject.uuid}/original.jpg",
          "images/#{subject.uuid}/processed.jpg",
          "images/#{subject.uuid}/span3.jpg",
          "images/#{subject.uuid}/span4.jpg",
          "images/#{subject.uuid}/span8.jpg",
          "images/#{subject.uuid}/span12.jpg"
        ].sort
      end
    end
  end
end
