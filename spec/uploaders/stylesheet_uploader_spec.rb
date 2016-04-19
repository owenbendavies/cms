require 'rails_helper'

RSpec.describe StylesheetUploader do
  let(:css) { "body {\r\n  padding: 4em;\r\n}" }
  let(:site) { FactoryGirl.create(:site) }
  subject { described_class.new(site) }

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

      expect(subject.uuid).to match(/\A[0-9a-f-]+\z/)

      expect(uploaded_files).to eq ["stylesheets/#{subject.uuid}/original.css"]
    end
  end
end
