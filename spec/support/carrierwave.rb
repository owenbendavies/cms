RSpec::Matchers.define :be_uploaded_file do
  match do |actual|
    file = File.join(
      CarrierWave.root,
      CarrierWave::Uploader::Base.store_dir,
      actual
    )

    File.exist?(file).should eq true
  end
end

shared_context 'clear_uploaded_files' do
  before do
    FileUtils.rm_rf File.join(
      CarrierWave.root,
      CarrierWave::Uploader::Base.store_dir
    )
  end
end
