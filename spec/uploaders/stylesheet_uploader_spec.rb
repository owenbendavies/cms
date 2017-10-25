require 'rails_helper'

RSpec.describe StylesheetUploader do
  subject(:stylesheet_uploader) { described_class.new(site) }

  let(:css) { "body {\r\n  padding: 4em;\r\n}" }
  let(:site) { FactoryBot.create(:site) }

  describe '.store!' do
    it 'must be css' do
      expect { stylesheet_uploader.store! StringUploader.new('stylesheet.exe', css) }
        .to raise_error(
          CarrierWave::IntegrityError,
          'You are not allowed to upload "exe" files, allowed types: css'
        )
    end

    it 'has filename which is uuid' do
      stylesheet_uploader.store! StringUploader.new('stylesheet.css', css)

      expect(stylesheet_uploader.uuid).to match(/\A[0-9a-f-]+\z/)
    end

    it 'stores file' do
      stylesheet_uploader.store! StringUploader.new('stylesheet.css', css)

      expect(uploaded_files).to eq ["stylesheets/#{stylesheet_uploader.uuid}/original.css"]
    end
  end
end
