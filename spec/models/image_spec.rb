require 'rails_helper'

RSpec.describe Image do
  it 'has accessors for its properties' do
    site = FactoryGirl.build(:site)

    image = Image.new(
      name: new_name,
      created_by: new_id,
      updated_by: new_id,
      site: site,
      filename: new_filename,
    )

    expect(image.name).to eq new_name
    expect(image.created_by).to eq new_id
    expect(image.updated_by).to eq new_id
    expect(image.site).to eq site
  end

  it 'has a file' do
    site = FactoryGirl.build(:site)
    image = FactoryGirl.build(:image, site: site)
    file = image.file

    expect(file.url).to eq File.join(
      image.asset_host,
      CarrierWave::Uploader::Base.store_dir,
      image.filename
    )

    expect(file.fog_directory).to eq image.fog_directory
  end

  it 'strips attributes' do
    image = FactoryGirl.create(:image, name: "  #{new_name} ")
    expect(image.name).to eq new_name
  end

  describe '#save' do
    let(:site) { FactoryGirl.create(:site) }
    subject { FactoryGirl.build(:image, site: site) }

    it 'saves site_id' do
      subject.save!
      expect(subject.site_id).to eq site.id
    end
  end

  describe 'validate' do
    it { should validate_presence_of(:site_id) }

    it { should validate_presence_of(:name) }

    it {
      should_not allow_value(
        '<a>bad</a>'
      ).for(:name).with_message('HTML not allowed')
    }

    it { should ensure_length_of(:name).is_at_most(64) }

    it { should validate_presence_of(:created_by) }

    it { should validate_presence_of(:updated_by) }
  end

  describe '.by_site_id_and_name' do
    it 'returns all images in alphabetical order' do
      image = FactoryGirl.create(:image, site_id: new_id)

      results = CouchPotato.database.view(
        Image.by_site_id_and_name(key: [new_id, image.name])
      )

      expect(results.size).to eq 1
      expect(results.first).to eq image
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
      expect(images.size).to eq 2
      expect(images.first).to eq image1
      expect(images.first.site).to eq site
      expect(images.second).to eq image2
    end
  end

  describe '#fog_directory' do
    it 'uses the site fog_directory' do
      site = FactoryGirl.build(:site)
      image = FactoryGirl.build(:image, site: site)

      expect(image.fog_directory).to eq site.fog_directory
    end
  end
end
