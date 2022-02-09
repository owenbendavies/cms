RSpec.shared_examples 'model with versioning', versioning: true do
  subject(:model) { create(described_class.to_s.underscore) }

  it 'records creates' do
    expect(model.versions.last.event).to eq 'create'
  end

  it 'records updated' do
    model.update!(updated_at: Time.zone.now)
    expect(model.versions.last.event).to eq 'update'
  end

  it 'records destroys' do
    model.destroy!
    expect(model.versions.last.event).to eq 'destroy'
  end
end
