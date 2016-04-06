class ValidateDataJob < ActiveJob::Base
  queue_as :default

  NON_MODEL_TABLES = %w(delayed_jobs schema_migrations versions).freeze

  def perform
    error_messages = model_errors

    return unless error_messages.any?

    message = "The following models had errors\n\n" + error_messages.join("\n") + "\n"

    SystemMailer.error(message).deliver_later
  end

  private

  def models
    all_table_names = ActiveRecord::Base.connection.tables
    model_tables = all_table_names - NON_MODEL_TABLES
    model_tables.sort.map(&:classify).map(&:constantize)
  end

  def model_errors
    error_messages = []

    models.map do |model|
      model.find_each do |record|
        next if record.valid?

        error_messages << "#{model}##{record.id}: " + record.errors.full_messages.join(', ')
      end
    end

    error_messages
  end
end
