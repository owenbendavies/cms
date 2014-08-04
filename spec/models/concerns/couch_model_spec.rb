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

  describe 'validate' do
    subject { TestCouchModel.new }

    it { should validate_presence_of(:name) }
  end

  describe '.by_id' do
    it 'returns all models' do
      FactoryGirl.create(:site)
      subject.save!

      results = CouchPotato.database.view(TestCouchModel.by_id)
      expect(results.size).to eq 1
      expect(results.first).to eq subject
    end
  end

  describe '.all' do
    it 'returns all models' do
      FactoryGirl.create(:site)
      subject.save!

      results = TestCouchModel.all
      expect(results.size).to eq 1
      expect(results.first).to eq subject
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
      expect(TestCouchModel.find_by_id(subject.id)).to eq subject
    end

    it 'returns nil if not found' do
      expect(TestCouchModel.find_by_id(new_id)).to be_nil
    end
  end

  describe '#save' do
    it 'saves the model' do
      expect {
        expect(subject.save).to eq true
      }.to change(TestCouchModel, :count).by(1)
    end

    it 'returns false if errors' do
      subject.name = nil

      expect {
        expect(subject.save).to eq false
      }.to change(TestCouchModel, :count).by(0)
    end
  end

  describe '#save!' do
    it 'saves the model' do
      expect {
        expect(subject.save!).to eq true
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
        expect(subject.update_attributes(name: new_name)).to eq true
      }.to change(TestCouchModel, :count).by(1)

      expect(subject.name).to eq new_name
    end

    it 'returns false if errors' do
      expect {
        expect(subject.update_attributes(name: nil)).to eq false
      }.to change(TestCouchModel, :count).by(0)
    end

    it 'sanitizes parameters' do
      parameters = ActionController::Parameters.new(name: new_name)

      subject.update_attributes(parameters.permit(:name))
      expect(subject.name).to eq new_name
    end

    it 'rejects bad parameters' do
      parameters = ActionController::Parameters.new(
        name: new_name
      )

      subject.update_attributes(parameters.permit(:another))
      expect(subject.name).to be_nil
    end
  end

  describe '#update_attributes!' do
    subject { TestCouchModel.new }

    it 'updates attributes and saves' do
      expect {
        expect(subject.update_attributes!(name: new_name)).to eq true
      }.to change(TestCouchModel, :count).by(1)

      expect(subject.name).to eq new_name
    end

    it 'raises an error if invalid' do
      expect {
        expect {
          expect(subject.update_attributes!(name: nil)).to
        }.to raise_error CouchPotato::Database::ValidationsFailedError
      }.to change(TestCouchModel, :count).by(0)
    end

    it 'sanitizes parameters' do
      parameters = ActionController::Parameters.new(
        name: new_name
      )

      subject.update_attributes!(parameters.permit(:name))
      expect(subject.name).to eq new_name
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
      expect(subject.read_attribute(:name)).to eq name
    end
  end

  describe '#write_attribute' do
    subject { TestCouchModel.new }

    it 'writes an attribute' do
      subject.write_attribute(:name, new_name)
      expect(subject.name).to eq new_name
    end
  end
end
