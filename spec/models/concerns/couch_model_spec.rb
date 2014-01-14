require 'spec_helper'

describe CouchModel do
  include_context 'new_fields'
  let(:name) { Faker::Name.name }

  class TestCouchModel
    include CouchModel

    property :name, type: String

    validates :name, presence: true
  end

  subject { TestCouchModel.new(name: name) }

  its(:name) { should eq name }

  describe 'validate' do
    subject { TestCouchModel.new }

    it { should validate_presence_of(:name) }
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
      subject.name = nil

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
      subject.name = nil

      expect {
        expect {
          subject.save!
        }.to raise_error CouchPotato::Database::ValidationsFailedError
      }.to change(TestCouchModel, :count).by(0)
    end
  end

  describe '#destroy' do
    it 'destroys the model' do
      subject.save!

      expect {
        subject.destroy
      }.to change(TestCouchModel, :count).by(-1)
    end
  end

  describe '#update_attributes' do
    subject { TestCouchModel.new }

    it 'updates attributes and saves' do
      expect {
        subject.update_attributes(name: new_name).should eq true
      }.to change(TestCouchModel, :count).by(1)

      subject.name.should eq new_name
    end

    it 'returns false if errors' do
      expect {
        subject.update_attributes(name: nil).should eq false
      }.to change(TestCouchModel, :count).by(0)
    end

    it 'sanitizes parameters' do
      parameters = ActionController::Parameters.new(name: new_name)

      subject.update_attributes(parameters.permit(:name))
      subject.name.should eq new_name
    end

    it 'rejects bad parameters' do
      parameters = ActionController::Parameters.new(
        name: new_name
      )

      subject.update_attributes(parameters.permit(:another))
      subject.name.should be_nil
    end
  end

  describe '#update_attributes!' do
    subject { TestCouchModel.new }

    it 'updates attributes and saves' do
      expect {
        subject.update_attributes!(name: new_name).should eq true
      }.to change(TestCouchModel, :count).by(1)

      subject.name.should eq new_name
    end

    it 'raises an error if invalid' do
      expect {
        expect {
          subject.update_attributes!(name: nil).should
        }.to raise_error CouchPotato::Database::ValidationsFailedError
      }.to change(TestCouchModel, :count).by(0)
    end

    it 'sanitizes parameters' do
      parameters = ActionController::Parameters.new(
        name: new_name
      )

      subject.update_attributes!(parameters.permit(:name))
      subject.name.should eq new_name
    end

    it 'rejects bad parameters' do
      parameters = ActionController::Parameters.new(
        name: new_name
      )

      expect {
        subject.update_attributes!(parameters.permit(:another))
      }.to raise_error CouchPotato::Database::ValidationsFailedError
    end
  end

  describe '#read_attribute' do
    it 'reads an attribute' do
      subject.read_attribute(:name).should eq name
    end
  end

  describe '#write_attribute' do
    subject { TestCouchModel.new }

    it 'writes an attribute' do
      subject.write_attribute(:name, new_name)
      subject.name.should eq new_name
    end
  end
end
