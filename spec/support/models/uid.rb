RSpec.shared_examples 'model with uid' do
  before do
    model.save!
  end

  describe '#save' do
    it 'sets a uid' do
      expect(model.uid).to match(/\A[0-9a-z]{8}+\z/)
    end
  end

  describe '#to_param' do
    it 'uses uid' do
      expect(model.to_param).to eq model.uid
    end
  end
end
