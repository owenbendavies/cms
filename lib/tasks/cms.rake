namespace :cms do
  desc 'Validate all database models'
  task validate_data: :environment do
    all_table_names = ActiveRecord::Base.connection.tables
    non_model_tables = %w(delayed_jobs schema_migrations versions)
    model_tables = all_table_names - non_model_tables

    error_messages = []

    model_tables.sort.map(&:classify).map(&:constantize).each do |model|
      model.find_each do |record|
        next if record.valid?

        error_messages << "#{model}##{record.id}: " + record.errors.full_messages.join(', ')
      end
    end

    unless error_messages.empty?
      message = "The following models had errors\n\n" + error_messages.join("\n") + "\n"
      SystemMailer.error(message).deliver_later
    end
  end
end
