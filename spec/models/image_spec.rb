require 'spec_helper'

describe Image do
  include_context 'new_fields'

  describe 'properties' do
    let(:site) { FactoryGirl.build(:site) }

    subject { Image.new(
      site_id: new_id,
      name: new_name,
      created_by: new_id,
      updated_by: new_id,
      site: site,
      filename: new_filename,
    )}

    its(:site_id) { should eq new_id }
    its(:name) { should eq new_name }
    its(:created_by) { should eq new_id }
    its(:updated_by) { should eq new_id }
    its(:site) { should eq site }
    its(:filename) { should eq new_filename }
    its(:asset_host) { should eq site.asset_host }
    its(:fog_directory) { should eq site.fog_directory }
  end

  describe 'file' do
    let(:site) { FactoryGirl.build(:site) }
    let(:image) { FactoryGirl.build(:image, site: site) }
    subject { image.file }

    its(:url) { should eq File.join(
      image.asset_host,
      CarrierWave::Uploader::Base.store_dir,
      image.filename
    )}

    its(:fog_directory) { should eq image.fog_directory }
  end

  describe '#auto_strip_attributes' do
    subject { FactoryGirl.create(:image, name: "  #{new_name} ")}
    its(:name) { should eq new_name }
  end

  describe '#save' do
    let(:site) { FactoryGirl.create(:site) }
    subject { FactoryGirl.build(:image, site: site) }

    it 'saves site_id' do
      subject.save!
      subject.site_id.should eq site.id
    end
  end

  describe 'validate' do
    it { should validate_presence_of(:site_id) }

    it { should validate_presence_of(:name) }

    it { should_not allow_values_for(
      :name,
      '<a>bad</a>',
      message: 'HTML not allowed'
    )}

    it { should validate_length_of(:name, maximum: 64) }

    it { should validate_presence_of(:created_by) }

    it { should validate_presence_of(:updated_by) }
  end

  describe '.by_site_id_and_name' do
    it 'returns all images in alphabetical order' do
      image = FactoryGirl.create(:image, site_id: new_id)

      results = CouchPotato.database.view(
        Image.by_site_id_and_name(key: [new_id, image.name])
      )

      results.size.should eq 1
      results.first.should eq image
    end
  end

  describe '.find_all_by_site' do
    it 'returns all images in alphabetical order' do
      site = FactoryGirl.create(:site)

      image1 = FactoryGirl.create( :image,
        site: site,
        name: "Image 1",
      )

      image2 = FactoryGirl.create(:image,
        site: site,
        name: "Image 2",
      )

      FactoryGirl.create(:image)

      images = Image.find_all_by_site(site)
      images.size.should eq 2
      images.first.should eq image1
      images.first.site.should eq site
      images.second.should eq image2
    end
  end
end
