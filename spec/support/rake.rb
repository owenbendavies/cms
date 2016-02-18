RSpec.configuration.before :all, type: :rake do
  Rails.application.load_tasks
end

RSpec.shared_context 'rake helpers', type: :rake do
  subject { Rake::Task[self.class.top_level_description] }
end
