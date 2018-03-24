require 'rails_helper'

RSpec.describe CarrierWave do
  subject(:uploaded_file) do
    fog_directory.files.get(uploader.store_path)
  end

  let(:site) { FactoryBot.build_stubbed(:site) }
  let(:uploader) { StylesheetUploader.new(site) }

  before do
    uploader.store! StringUploader.new('stylesheet.css', 'bob')
  end

  it 'sets cache as 1 year' do
    expect(uploaded_file.cache_control).to eq 'public, max-age=31557600'
  end

  it 'uploads files as private' do
    expect(uploader.fog_public).to eq false
  end
end
