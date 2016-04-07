RSpec.configure do |config|
  config.after :each do
    ObjectSpace.each_object(File) do |file|
      next if file.closed?
      next if file.path == '/dev/null'
      next if file.path == Rails.root.join('log/test.log').to_s
      next if file.path.end_with? '.pry_history'
      next if file.path.end_with? 'zxcvbn.js'

      raise "You have not closed #{file.path}"
    end
  end

  config.after :suite do
    limit = 350
    memory = GetProcessMem.new.mb.to_i

    puts "\nTotal test memory is #{memory} MB"
    raise "ERROR: Memory above limit of #{limit} MB" if memory > limit
  end

  config.after :suite do
    limit = 2.minutes
    duration = Time.zone.now - config.start_time

    raise "ERROR: Duration above limit of #{limit}s" if duration > limit
  end
end
