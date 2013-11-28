require 'spec_helper'

describe ImageUploader do
  include CarrierWave::Test::Matchers
  include_context 'clear_uploaded_files'

  let(:site) { FactoryGirl.build(:site) }
  let(:image) { FactoryGirl.build(:image, site: site) }
  subject { ImageUploader.new(image) }

  describe 'store' do
    it 'must be an image' do
      expect {
        subject.store! StringUploader.new("stylesheet.exe", 'asd')
      }.to raise_error(
        CarrierWave::IntegrityError,
        /.* "exe" files, allowed types: jpg, jpeg, png/
      )
    end

    it 'has filename which is  md5 of content' do
      files = [
        'a7a78bb78134027c41d2eedc6efd4edb.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span1.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span2.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span3.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span4.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span8.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span10.jpg',
        'a7a78bb78134027c41d2eedc6efd4edb_span12.jpg',
      ].map{|file| Rails.root.join('public/uploads', file).to_s}

      Dir.glob(Rails.root.join('public/uploads/*')).should be_empty

      subject.store! File.open(Rails.root.join('spec/assets/test_image.jpg'))

      Dir.glob(Rails.root.join('public/uploads/*')).sort.should eq files.sort
    end

    it 'creates multiple sized images at same aspect ratio' do
      subject.store! File.open(Rails.root.join('spec/assets/test_image.jpg'))

      subject.span1.should have_dimensions(60, 60)
      subject.span2.should have_dimensions(140, 140)
      subject.span3.should have_dimensions(220, 165)
      subject.span4.should have_dimensions(300, 225)
      subject.span8.should have_dimensions(620, 465)
      subject.span10.should have_dimensions(780, 585)
      subject.span12.should have_dimensions(940, 705)
    end

    it 'does not enlarge images' do
      subject.store! File.open(Rails.root.join('spec/assets/small.jpg'))

      subject.span1.should have_dimensions(60, 60)
      subject.span2.should have_dimensions(140, 140)
      subject.span3.should have_dimensions(80, 80)
      subject.span4.should have_dimensions(80, 80)
      subject.span8.should have_dimensions(80, 80)
      subject.span10.should have_dimensions(80, 80)
      subject.span12.should have_dimensions(80, 80)
    end

    it 'saves extension as downcase' do
      Dir.glob(Rails.root.join('public/uploads/*')).should be_empty

      subject.store! File.open(Rails.root.join('spec/assets/test_image.JPG'))

      'a7a78bb78134027c41d2eedc6efd4edb.jpg'.should be_uploaded_file
      'a7a78bb78134027c41d2eedc6efd4edb_span12.jpg'.should be_uploaded_file
    end

    it 'saves .jpeg as jpg' do
      Dir.glob(Rails.root.join('public/uploads/*')).should be_empty

      subject.store! File.open(Rails.root.join('spec/assets/test_image.jpeg'))

      'a7a78bb78134027c41d2eedc6efd4edb.jpg'.should be_uploaded_file
      'a7a78bb78134027c41d2eedc6efd4edb_span12.jpg'.should be_uploaded_file
    end
  end

  its(:asset_host) { should eq site.asset_host }
  its(:fog_directory) { should eq site.fog_directory }
end
