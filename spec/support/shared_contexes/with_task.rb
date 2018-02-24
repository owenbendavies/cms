RSpec.shared_context 'with task' do
  before do
    Rake::Task.clear
    Rails.application.load_tasks
  end

  subject(:task) { Rake::Task[self.class.top_level_description] }
end

RSpec.configuration.include_context 'with task', type: :task
