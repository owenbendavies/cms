RSpec.configure do |config|
  config.after :each do
    memory = GetProcessMem.new.mb.to_i

    fail "Memory is too high: #{memory} MB" if memory > 400
  end

  config.after :each do
    ObjectSpace.each_object(File) do |file|
      next if file.closed?
      next if file.path == '/dev/null'
      next if file.path == Rails.root.join('log/test.log').to_s

      fail "You have not closed #{file.path}"
    end
  end
end
