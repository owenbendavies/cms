require 'spec_helper'

describe CouchModel do
  include_context 'new_fields'

  class TestCouchModel
    include CouchModel
  end

  subject { TestCouchModel.new(updated_from: new_ip_address) }

  its(:updated_from) { should eq new_ip_address }

  describe 'validate' do
    subject { TestCouchModel.new }

    it { should validate_presence_of(:updated_from) }

    it { should allow_values_for(
      :updated_from,
      '255.255.255.255',
      '1.1.1.1',
      '2001:0db8:0000:0000:0000:ff00:0042:8329',
      '2001:db8:0:0:0:ff00:42:8329',
      '2001:db8::ff00:42:8329',
    )}

    it { should_not allow_values_for(
      :updated_from,
      '9x',
      '2.3.2',
      '323.232.123.231',
      '2001:db8:0:0:0:ff00:42:xxxx',
    )}
  end

  describe '.by_id' do
    it 'returns all models' do
      FactoryGirl.create(:site)
      subject.save!

      results = CouchPotato.database.view(TestCouchModel.by_id)
      results.size.should eq 1
      results.first.should eq subject
    end
  end

  describe '.all' do
    it 'returns all models' do
      FactoryGirl.create(:site)
      subject.save!

      results = TestCouchModel.all
      results.size.should eq 1
      results.first.should eq subject
    end
  end

  describe '.count' do
    it 'returns number of models' do
      expect {
        subject.save!
      }.to change(TestCouchModel, :count).by(1)
    end
  end

  describe '.find_by_id' do
    it 'returns the model' do
      subject.save!
      TestCouchModel.find_by_id(subject.id).should eq subject
    end

    it 'returns nil if not found' do
      TestCouchModel.find_by_id(new_id).should be_nil
    end
  end

  describe '#save' do
    it 'saves the model' do
      expect {
        subject.save.should eq true
      }.to change(TestCouchModel, :count).by(1)
    end

    it 'returns false if errors' do
      subject.updated_from = nil

      expect {
        subject.save.should eq false
      }.to change(TestCouchModel, :count).by(0)
    end
  end

  describe '#save!' do
    it 'saves the model' do
      expect {
        subject.save!.should eq true
      }.to change(TestCouchModel, :count).by(1)
    end

    it 'raises an error if invalid' do
      subject.updated_from = nil

      expect {
        expect {
          subject.save!
        }.to raise_error CouchPotato::Database::ValidationsFailedError
      }.to change(TestCouchModel, :count).by(0)
    end
  end

  describe '#update_attributes' do
    subject { TestCouchModel.new }

    it 'updates attributes and saves' do
      expect {
        subject.update_attributes(updated_from: new_ip_address).should eq true
      }.to change(TestCouchModel, :count).by(1)

      subject.updated_from.should eq new_ip_address
    end

    it 'returns false if errors' do
      expect {
        subject.update_attributes(updated_from: nil).should eq false
      }.to change(TestCouchModel, :count).by(0)
    end

    it 'sanitizes parameters' do
      parameters = ActionController::Parameters.new(
        updated_from: new_ip_address
      )

      subject.update_attributes(parameters.permit(:updated_from))
      subject.updated_from.should eq new_ip_address
    end

    it 'rejects bad parameters' do
      parameters = ActionController::Parameters.new(
        updated_from: new_ip_address
      )

      subject.update_attributes(parameters.permit(:another))
      subject.updated_from.should be_nil
    end
  end

  describe '#update_attributes!' do
    subject { TestCouchModel.new }

    it 'updates attributes and saves' do
      expect {
        subject.update_attributes!(updated_from: new_ip_address).should eq true
      }.to change(TestCouchModel, :count).by(1)

      subject.updated_from.should eq new_ip_address
    end

    it 'raises an error if invalid' do
      expect {
        expect {
          subject.update_attributes!(updated_from: nil).should
        }.to raise_error CouchPotato::Database::ValidationsFailedError
      }.to change(TestCouchModel, :count).by(0)
    end

    it 'sanitizes parameters' do
      parameters = ActionController::Parameters.new(
        updated_from: new_ip_address
      )

      subject.update_attributes!(parameters.permit(:updated_from))
      subject.updated_from.should eq new_ip_address
    end

    it 'rejects bad parameters' do
      parameters = ActionController::Parameters.new(
        updated_from: new_ip_address
      )

      expect {
        subject.update_attributes!(parameters.permit(:another))
      }.to raise_error CouchPotato::Database::ValidationsFailedError
    end
  end

  describe '#read_attribute' do
    it 'reads an attribute' do
      subject.read_attribute(:updated_from).should eq new_ip_address
    end
  end

  describe '#write_attribute' do
    subject { TestCouchModel.new }

    it 'writes an attribute' do
      subject.write_attribute(:updated_from, new_ip_address)
      subject.updated_from.should eq new_ip_address
    end
  end
end
