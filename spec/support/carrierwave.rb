CarrierWave.configure do |config|
  config.storage = :file

  config.store_dir = 'uploads'
end

RSpec::Matchers.define :be_uploaded_file do
  match do |actual|
    File.exist?(Rails.root.join('public/uploads', actual)).should eq true
  end
end

shared_context 'clear_uploaded_files' do
  before do
    FileUtils.rm_rf Rails.root.join('public/uploads')
  end
end
