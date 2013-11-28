require 'spec_helper'

describe StringUploader do

  subject { StringUploader.new('filename.txt', 'text') }

  its(:original_filename) { should eq 'filename.txt' }
  its(:read) { should eq 'text' }
end
