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

  config.after :each do
    expect(Delayed::Job.count).to eq 0
  end

  config.after :suite do
    expect(GetProcessMem.new.mb.to_i).to be < 350
  end

  config.after :suite do
    expect(Time.zone.now - config.start_time).to be < 150
  end
end
