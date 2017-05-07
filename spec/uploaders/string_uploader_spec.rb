require 'rails_helper'

RSpec.describe StringUploader do
  subject(:string_uploader) { described_class.new('filename.txt', 'text') }

  it 'has a filename' do
    expect(string_uploader.original_filename).to eq 'filename.txt'
  end

  it 'returns file contents' do
    expect(string_uploader.read).to eq 'text'
  end
end
