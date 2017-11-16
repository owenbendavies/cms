RSpec.configure do |config|
  config.before :each, type: :task do
    Rake::Task.clear
    Rails.application.load_tasks
  end
end

RSpec.shared_context 'with tasks' do
  subject(:task) { Rake::Task[self.class.top_level_description] }
end

RSpec.configuration.include_context 'with tasks', type: :task
