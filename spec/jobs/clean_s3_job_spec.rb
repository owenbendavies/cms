require 'rails_helper'

RSpec.describe CleanS3Job do
  let!(:sysadmin) { FactoryGirl.create(:sysadmin) }

  context 'with no files' do
    it 'does not send an email' do
      described_class.perform_now

      expect(ActionMailer::Base.deliveries.size).to eq 0
      Delayed::Worker.new.work_off
      expect(ActionMailer::Base.deliveries.size).to eq 0
    end
  end

  context 'with valid files' do
    before do
      Rails.root.join('spec/assets/test_image.jpg').open do |file|
        FactoryGirl.create(:image, file: file)
      end

      css_file = StringUploader.new('stylesheet.css', 'body {padding: 4em}')
      FactoryGirl.create(:site, stylesheet: css_file)
    end

    let!(:good_files) { uploaded_files }

    it 'does not send an email' do
      described_class.perform_now

      expect(uploaded_files).to eq good_files

      expect(ActionMailer::Base.deliveries.size).to eq 0
      Delayed::Worker.new.work_off
      expect(ActionMailer::Base.deliveries.size).to eq 0
    end

    context 'with invalid files' do
      before do
        fog_directory.files.create(key: 'bad.jpg')
      end

      it 'sends an email' do
        expect(uploaded_files).to include 'bad.jpg'

        described_class.perform_now

        expect(uploaded_files).not_to include 'bad.jpg'
        expect(uploaded_files).to eq good_files

        expect(ActionMailer::Base.deliveries.size).to eq 0
        Delayed::Worker.new.work_off
        expect(ActionMailer::Base.deliveries.size).to eq 1

        expect(ActionMailer::Base.deliveries.last.body.to_s).to eq <<EOF
The following S3 files where deleted

bad.jpg
EOF
      end
    end
  end
end
