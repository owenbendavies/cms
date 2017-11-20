RSpec.configure do |config|
  config.after do
    ObjectSpace.each_object(File) do |file|
      next if file.closed?
      next if file.path == '/dev/null'
      next if file.path.end_with? '.pry_history'
      next if file.path =~ /^#{Rails.root.join('log')}.*.log/
      next if file.path =~ /^#{Rails.root.join('app')}.*/

      raise "You have not closed #{file.path}"
    end
  end

  config.after do
    raise 'Delayed::Job not processed' unless Delayed::Job.count == 0
  end

  config.after :suite do
    raise 'Memory too hight' if GetProcessMem.new.mb.to_i > 512
  end

  config.after :suite do
    time = Time.zone.now - config.start_time
    raise 'Tests took too long' if time > 8.minutes
  end
end
