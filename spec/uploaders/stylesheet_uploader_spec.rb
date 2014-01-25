require 'spec_helper'

describe StylesheetUploader do
  include_context 'clear_uploaded_files'

  let(:css) { "body {\r\n  padding: 4em;\r\n}" }

  let(:site) { FactoryGirl.build(:site) }
  subject { StylesheetUploader.new(site) }

  describe 'store' do
    it 'must be css' do
      expect {
        subject.store! StringUploader.new("stylesheet.exe", css)
      }.to raise_error(
        CarrierWave::IntegrityError,
        'You are not allowed to upload "exe" files, allowed types: css'
      )
    end

    it 'has filename which is  md5 of content' do
      uploaded_files.should eq []

      subject.store! StringUploader.new("stylesheet.css", css)

      uploaded_files.should eq ['e6df26f541ebad8e8fed26a84e202a7c.css']
    end
  end

  its(:asset_host) { should eq site.asset_host }
  its(:fog_directory) { should eq site.fog_directory }
end
