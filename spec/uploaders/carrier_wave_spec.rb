require 'rails_helper'

RSpec.describe CarrierWave do
  subject(:uploaded_file) do
    fog_directory.files.get(uploader.store_path)
  end

  let(:site) { FactoryBot.create(:site) }
  let(:uploader) { StylesheetUploader.new(site) }

  it 'sets cache as 1 year' do
    uploader.store! StringUploader.new('stylesheet.css', 'bob')
    expect(uploaded_file.cache_control).to eq 'public, max-age=31557600'
  end
end
