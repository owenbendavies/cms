RSpec.shared_context 'models', type: :model do
  context '#versions', versioning: true do
    subject { FactoryGirl.create(described_class.to_s.underscore) }

    it 'records creates' do
      expect(subject.versions.count).to eq 1
      expect(subject.versions.last.event).to eq 'create'
    end

    it 'records updated' do
      subject.update!(updated_at: Time.zone.now)
      expect(subject.versions.count).to eq 2
      expect(subject.versions.last.event).to eq 'update'
    end

    it 'records destroys' do
      subject.destroy!
      expect(subject.versions.count).to eq 2
      expect(subject.versions.last.event).to eq 'destroy'
    end
  end
end
