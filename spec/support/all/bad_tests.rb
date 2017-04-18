RSpec.configure do |config|
  config.after :each do
    ObjectSpace.each_object(File) do |file|
      next if file.closed?
      next if file.path == '/dev/null'
      next if file.path.end_with? '.pry_history'
      next if file.path =~ /^#{Rails.root.join('log')}.*.log/
      next if file.path =~ /^#{Rails.root.join('app')}.*/

      raise "You have not closed #{file.path}"
    end
  end

  config.after :each do
    expect(Delayed::Job.count).to eq 0
  end

  config.after :suite do
    expect(GetProcessMem.new.mb.to_i).to be < 512
  end

  config.after :suite do
    expect(Time.zone.now - config.start_time).to be < 8.minutes
  end
end
