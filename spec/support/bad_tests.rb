RSpec.configure do |config|
  config.after :each do
    ObjectSpace.each_object(File) do |file|
      next if file.closed?
      next if file.path == '/dev/null'
      next if file.path == Rails.root.join('log/test.log').to_s

      fail "You have not closed #{file.path}"
    end
  end

  config.after :suite do
    limit = 350
    memory = GetProcessMem.new.mb.to_i

    if memory > limit
      fail "FAIL: Tests too too much memory: total=#{memory} MB limit=#{limit} MB"
    else
      puts "INFO: Total test memory is #{memory} MB"
    end
  end

  if ENV['COVERAGE']
    config.after :suite do
      limit = 2.minutes
      duration = Time.zone.now - config.start_time

      fail "FAIL: Tests took too long: total=#{duration.to_i}s limit=#{limit}s" if duration > limit
    end
  end
end
