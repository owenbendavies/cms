begin
  MODELS = (
    ActiveRecord::Base.connection.tables -
    %w[ar_internal_metadata schema_migrations versions].freeze
  ).sort.map(&:classify).map { |name| name.gsub('DelayedJob', 'Delayed::Job') }.map(&:constantize)

  MODELS.map(&:new) # Used to load all SchemaPlus data before any requests are made
rescue ActiveRecord::NoDatabaseError
  STDOUT.puts 'Database not yet created'
end
