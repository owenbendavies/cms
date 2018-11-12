RSpec.shared_context 'when on mobile' do
  before do
    windows.first.resize_to(300, 600)
  end
end
