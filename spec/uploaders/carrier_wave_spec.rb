require 'rails_helper'

RSpec.describe CarrierWave do
  subject(:uploaded_file) do
    fog_directory.files.get(uploader.store_path)
  end

  let(:site) { FactoryBot.build_stubbed(:site) }
  let(:uploader) { ImageUploader.new(Image.new(site: site)) }

  before do
    File.open(Rails.root.join('spec/assets/small.jpg')) do |file|
      uploader.store! file
    end
  end

  it 'sets cache as 1 year' do
    expect(uploaded_file.cache_control).to eq 'public, max-age=31556952'
  end

  it 'uploads files as private' do
    expect(uploader.fog_public).to eq false
  end
end
