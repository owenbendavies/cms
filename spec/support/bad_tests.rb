RSpec.configure do |config|
  config.after :each do
    ObjectSpace.each_object(File) do |file|
      next if file.closed?
      next if file.path == '/dev/null'
      next if file.path == Rails.root.join('log/test.log').to_s

      fail "You have not closed #{file.path}"
    end
  end

  config.after :each do
    memory = GetProcessMem.new.mb.to_i

    fail "Memory is too high: #{memory} MB" if memory > 350
  end

  config.after :suite do
    memory = GetProcessMem.new.mb.to_i

    puts "Test memory is #{memory} MB"
  end

  if ENV['COVERAGE']
    config.after :suite do
      duration = Time.zone.now - config.start_time

      if duration > 2.minutes
        fail "Tests took too long: total=#{duration.to_i}s"
      end
    end
  end
end
