RSpec.shared_context 'with task' do
  subject(:task) { Rake::Task[self.class.top_level_description] }

  before do
    Rake::Task.clear
    Rails.application.load_tasks
  end
end

RSpec.configuration.include_context 'with task', type: :task
