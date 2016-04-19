require 'rails_helper'

RSpec.describe ImageUploader do
  let(:site) { FactoryGirl.create(:site) }
  subject { described_class.new(Image.new(site: site)) }

  describe '.store!' do
    it 'must be an image' do
      expect { subject.store! StringUploader.new('stylesheet.exe', 'asd') }
        .to raise_error(
          CarrierWave::IntegrityError,
          /.* "exe" files, allowed types: jpg, jpeg, png/
        )
    end

    it 'has filename which is uuid' do
      expect(uploaded_files).to eq []

      File.open(Rails.root.join('spec/assets/test_image.jpg')) do |file|
        subject.store! file
      end

      expect(subject.uuid).to match(/\A[0-9a-f-]+\z/)

      expect(uploaded_files).to eq [
        "images/#{subject.uuid}/original.jpg",
        "images/#{subject.uuid}/span3.jpg",
        "images/#{subject.uuid}/span4.jpg",
        "images/#{subject.uuid}/span8.jpg",
        "images/#{subject.uuid}/span12.jpg"
      ].sort
    end

    it 'creates multiple sized images at same aspect ratio' do
      File.open(Rails.root.join('spec/assets/test_image.jpg')) do |file|
        subject.store! file
      end

      image = remote_image(subject.span3)
      expect(image[:width]).to eq 220
      expect(image[:height]).to eq 165

      image = remote_image(subject.span4)
      expect(image[:width]).to eq 300
      expect(image[:height]).to eq 225

      image = remote_image(subject.span8)
      expect(image[:width]).to eq 620
      expect(image[:height]).to eq 465

      image = remote_image(subject.span12)
      expect(image[:width]).to eq 940
      expect(image[:height]).to eq 705
    end

    it 'does not enlarge images' do
      File.open(Rails.root.join('spec/assets/small.jpg')) do |file|
        subject.store! file
      end

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

    it 'saves extension as downcase' do
      expect(uploaded_files).to eq []

      File.open(Rails.root.join('spec/assets/test_image.JPG')) do |file|
        subject.store! file
      end

      expect(uploaded_files).to eq [
        "images/#{subject.uuid}/original.jpg",
        "images/#{subject.uuid}/span3.jpg",
        "images/#{subject.uuid}/span4.jpg",
        "images/#{subject.uuid}/span8.jpg",
        "images/#{subject.uuid}/span12.jpg"
      ].sort
    end

    it 'saves .jpeg as jpg' do
      expect(uploaded_files).to eq []

      File.open(Rails.root.join('spec/assets/test_image.jpeg')) do |file|
        subject.store! file
      end

      expect(uploaded_files).to eq [
        "images/#{subject.uuid}/original.jpg",
        "images/#{subject.uuid}/span3.jpg",
        "images/#{subject.uuid}/span4.jpg",
        "images/#{subject.uuid}/span8.jpg",
        "images/#{subject.uuid}/span12.jpg"
      ].sort
    end
  end
end
