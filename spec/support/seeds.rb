RSpec.shared_context 'seeds' do
  def generate_seeds
    Rails.application.load_seed
  end
end

RSpec.configuration.include_context 'seeds', type: :seed
