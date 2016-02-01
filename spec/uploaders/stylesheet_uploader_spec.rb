require 'rails_helper'

RSpec.describe StylesheetUploader do
  let(:css) { "body {\r\n  padding: 4em;\r\n}" }
  let(:site) { FactoryGirl.create(:site) }
  subject { described_class.new(site) }

  describe '#store_dir' do
    it 'delegates to site' do
      expect(subject.store_dir).to eq site.store_dir
    end
  end

  describe '.store!' do
    it 'must be css' do
      expect { subject.store! StringUploader.new('stylesheet.exe', css) }
        .to raise_error(
          CarrierWave::IntegrityError,
          'You are not allowed to upload "exe" files, allowed types: css'
        )
    end

    it 'has filename which is uuid' do
      expect(uploaded_files).to eq []

      subject.store! StringUploader.new('stylesheet.css', css)

      uuid = File.basename(uploaded_files.first, '.css')
      expect(uploaded_files).to eq ["#{site.id}/#{uuid}.css"]
    end
  end
end
