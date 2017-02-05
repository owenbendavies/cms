RSpec.shared_context 'seed helpers' do
  def generate_seeds
    Rails.application.load_seed
  end
end

RSpec.configuration.include_context 'seed helpers', type: :seed
