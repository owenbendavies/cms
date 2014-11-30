require 'rails_helper'

RSpec.describe StringUploader do
  subject { StringUploader.new('filename.txt', 'text') }

  it 'has a filename' do
    expect(subject.original_filename).to eq 'filename.txt'
  end

  it 'returns file contents' do
    expect(subject.read).to eq 'text'
  end
end
