require 'rails_helper'

RSpec.describe SystemMailer do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:sysadmin) { FactoryGirl.create(:sysadmin) }

  describe '.error' do
    subject { described_class.error('Something went wrong', ['error 1', 'error 2']) }

    it 'is sent to sysadmins' do
      expect(subject.to).to eq [sysadmin.email]
    end

    it 'has from address' do
      expect(subject.from).to eq ['noreply@example.com']
    end

    it 'has subject' do
      expect(subject.subject).to eq 'ERROR on cms-test'
    end

    it 'has text in body' do
      expect(subject.body).to eq <<EOF
Something went wrong

error 1
error 2
EOF
    end
  end
end
