require 'rails_helper'

RSpec.describe CleanS3Job do
  let!(:sysadmin) { FactoryGirl.create(:user, :sysadmin) }

  context 'with no files' do
    it 'does not send any errors to Rollbar' do
      expect(Rollbar).not_to receive(:error)
      described_class.perform_now
    end
  end

  context 'with files' do
    let!(:image) do
      Rails.root.join('spec', 'assets', 'test_image.jpg').open do |file|
        FactoryGirl.create(:image, file: file)
      end
    end

    let!(:site) do
      css_file = StringUploader.new('stylesheet.css', 'body {padding: 4em}')
      FactoryGirl.create(:site, stylesheet: css_file)
    end

    let!(:good_files) { uploaded_files }

    it 'does not send any errors to Rollbar if all good' do
      expect(Rollbar).not_to receive(:error)
      described_class.perform_now
      expect(uploaded_files).to eq good_files
    end

    context 'with invalid file' do
      before do
        fog_directory.files.create(key: 'bad.jpg')
      end

      it 'sends an error to Rollbar' do
        expect(uploaded_files).to include 'bad.jpg'

        error = 'CleanS3Job deleted the following file: bad.jpg'
        expect(Rollbar).to receive(:error).with(error).and_call_original

        described_class.perform_now

        expect(uploaded_files).to eq good_files
      end
    end

    context 'with missing files' do
      before do
        fog_directory.files.destroy image.file.span3.path
      end

      it 'sends an error to Rollbar' do
        error = "CleanS3Job found the following file is missing: #{image.file.span3.path}"
        expect(Rollbar).to receive(:error).with(error).and_call_original

        described_class.perform_now
      end
    end
  end
end
