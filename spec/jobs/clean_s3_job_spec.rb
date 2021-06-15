require 'rails_helper'

RSpec.describe CleanS3Job do
  context 'without files' do
    it 'does not send any errors to Rollbar' do
      expect(Rollbar).not_to receive(:error)
      described_class.perform_now
    end
  end

  context 'with files' do
    let!(:image) do
      Rails.root.join('spec/assets/test_image.jpg').open do |file|
        FactoryBot.create(:image, file: file)
      end
    end

    it 'does not send any errors to Rollbar if all good' do
      expect(Rollbar).not_to receive(:error)
      described_class.perform_now
    end

    it 'does not delete any files' do
      expect { described_class.perform_now }
        .not_to(change { uploaded_files })
    end

    context 'with invalid file' do
      let!(:good_files) { uploaded_files }

      before do
        fog_directory.files.create(key: 'bad.jpg')
      end

      it 'sends an error to Rollbar' do
        error = 'CleanS3Job deleted unknown file'
        extra = { job: 'CleanS3Job', deleted_file: 'bad.jpg' }
        expect(Rollbar).to receive(:error).with(error, extra).and_call_original

        described_class.perform_now
      end

      it 'does not delete any files' do
        described_class.perform_now

        expect(uploaded_files).to eq good_files
      end
    end

    context 'with missing files' do
      before do
        fog_directory.files.destroy image.file.span3.path
      end

      it 'sends an error to Rollbar' do
        error = 'CleanS3Job found missing file'
        extra = { job: 'CleanS3Job', missing_file: image.file.span3.path }
        expect(Rollbar).to receive(:error).with(error, extra).and_call_original

        described_class.perform_now
      end
    end
  end
end
