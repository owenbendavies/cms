require 'rails_helper'

RSpec.describe ImageUploader do
  let(:site) { FactoryGirl.create(:site) }
  let(:image) { FactoryGirl.build(:image, site: site) }
  subject { described_class.new(image) }

  describe '#store_dir' do
    it 'delegates to site' do
      expect(subject.store_dir).to eq site.store_dir
    end
  end

  describe '.store!' do
    it 'must be an image' do
      expect { subject.store! StringUploader.new('stylesheet.exe', 'asd') }
        .to raise_error(
          CarrierWave::IntegrityError,
          /.* "exe" files, allowed types: jpg, jpeg, png/
        )
    end

    it 'has filename which is md5 of content' do
      expect(uploaded_files).to eq []

      File.open(Rails.root.join('spec/assets/test_image.jpg')) do |file|
        subject.store! file
      end

      expect(uploaded_files).to eq [
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span1.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span2.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span3.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span4.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span8.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span10.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span12.jpg"
      ].sort
    end

    it 'creates multiple sized images at same aspect ratio' do
      File.open(Rails.root.join('spec/assets/test_image.jpg')) do |file|
        subject.store! file
      end

      image = remote_image(subject.span1)
      expect(image[:width]).to eq 60
      expect(image[:height]).to eq 60

      image = remote_image(subject.span2)
      expect(image[:width]).to eq 140
      expect(image[:height]).to eq 140

      image = remote_image(subject.span3)
      expect(image[:width]).to eq 220
      expect(image[:height]).to eq 165

      image = remote_image(subject.span4)
      expect(image[:width]).to eq 300
      expect(image[:height]).to eq 225

      image = remote_image(subject.span8)
      expect(image[:width]).to eq 620
      expect(image[:height]).to eq 465

      image = remote_image(subject.span10)
      expect(image[:width]).to eq 780
      expect(image[:height]).to eq 585

      image = remote_image(subject.span12)
      expect(image[:width]).to eq 940
      expect(image[:height]).to eq 705
    end

    it 'does not enlarge images' do
      File.open(Rails.root.join('spec/assets/small.jpg')) do |file|
        subject.store! file
      end

      image = remote_image(subject.span1)
      expect(image[:width]).to eq 60
      expect(image[:height]).to eq 60

      image = remote_image(subject.span2)
      expect(image[:width]).to eq 140
      expect(image[:height]).to eq 140

      image = remote_image(subject.span3)
      expect(image[:width]).to eq 80
      expect(image[:height]).to eq 80

      image = remote_image(subject.span4)
      expect(image[:width]).to eq 80
      expect(image[:height]).to eq 80

      image = remote_image(subject.span8)
      expect(image[:width]).to eq 80
      expect(image[:height]).to eq 80

      image = remote_image(subject.span10)
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
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span1.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span2.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span3.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span4.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span8.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span10.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span12.jpg"
      ].sort
    end

    it 'saves .jpeg as jpg' do
      expect(uploaded_files).to eq []

      File.open(Rails.root.join('spec/assets/test_image.jpeg')) do |file|
        subject.store! file
      end

      expect(uploaded_files).to eq [
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span1.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span2.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span3.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span4.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span8.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span10.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_span12.jpg"
      ].sort
    end
  end
end
