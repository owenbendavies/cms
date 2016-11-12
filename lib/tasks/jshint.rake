if defined? Jshintrb
  require 'jshintrb/jshinttask'

  Jshintrb::JshintTask.new :jshint do |t|
    t.pattern = 'app/assets/javascripts/**/*.js'
    t.globals = %w($ autosize)
    t.options = :defaults
  end
end
