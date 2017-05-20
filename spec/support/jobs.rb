RSpec.shared_context 'jobs' do
  let(:query_limit) { 1 }

  def run_job
    expect { described_class.perform_now }.not_to exceed_query_limit(query_limit)
  end
end

RSpec.configuration.include_context 'jobs', type: :job
