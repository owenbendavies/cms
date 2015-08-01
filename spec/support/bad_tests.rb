RSpec.configure do |config|
  config.after :each do
    memory = GetProcessMem.new.mb.to_i

    fail "Memory is too high: #{memory} MB" if memory > 400
  end
end
