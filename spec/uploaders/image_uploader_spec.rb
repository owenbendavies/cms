require 'rails_helper'

RSpec.describe ImageUploader do
  include CarrierWave::Test::Matchers
  include_context 'clear_uploaded_files'

  let(:site) { FactoryGirl.build(:site) }
  let(:image) { FactoryGirl.build(:image, site: site) }
  subject { ImageUploader.new(image) }

  describe 'store' do
    it 'must be an image' do
      expect {
        subject.store! File.open(Rails.root.join('spec/assets/bad.exe'))
      }.to raise_error(
        CarrierWave::IntegrityError,
        /.* "exe" files, allowed types: jpg, jpeg, png/
      )
    end

    it 'has filename which is  md5 of content' do
      expect(uploaded_files).to eq []

      subject.store! File.open(Rails.root.join('spec/assets/test_image.jpg'))

      expect(uploaded_files).to eq [
        'a7a78bb78134027c41d2eedc6efd4edb.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span1.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span2.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span3.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span4.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span8.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span10.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span12.jpg',
      ].sort
    end

    it 'creates multiple sized images at same aspect ratio' do
      subject.store! File.open(Rails.root.join('spec/assets/test_image.jpg'))

      expect(subject.span1).to have_dimensions(60, 60)
      expect(subject.span2).to have_dimensions(140, 140)
      expect(subject.span3).to have_dimensions(220, 165)
      expect(subject.span4).to have_dimensions(300, 225)
      expect(subject.span8).to have_dimensions(620, 465)
      expect(subject.span10).to have_dimensions(780, 585)
      expect(subject.span12).to have_dimensions(940, 705)
    end

    it 'does not enlarge images' do
      subject.store! File.open(Rails.root.join('spec/assets/small.jpg'))

      expect(subject.span1).to have_dimensions(60, 60)
      expect(subject.span2).to have_dimensions(140, 140)
      expect(subject.span3).to have_dimensions(80, 80)
      expect(subject.span4).to have_dimensions(80, 80)
      expect(subject.span8).to have_dimensions(80, 80)
      expect(subject.span10).to have_dimensions(80, 80)
      expect(subject.span12).to have_dimensions(80, 80)
    end

    it 'saves extension as downcase' do
      expect(uploaded_files).to eq []

      subject.store! File.open(Rails.root.join('spec/assets/test_image.JPG'))

      expect(uploaded_files).to eq [
        'a7a78bb78134027c41d2eedc6efd4edb.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span1.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span2.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span3.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span4.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span8.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span10.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span12.jpg',
      ].sort
    end

    it 'saves .jpeg as jpg' do
      expect(uploaded_files).to eq []

      subject.store! File.open(Rails.root.join('spec/assets/test_image.jpeg'))

      expect(uploaded_files).to eq [
        'a7a78bb78134027c41d2eedc6efd4edb.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span1.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span2.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span3.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span4.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span8.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span10.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span12.jpg',
      ].sort
    end
  end
end
