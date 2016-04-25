class ValidateDataJob < ActiveJob::Base
  ERROR_MESSAGE = 'The following models had errors'.freeze
  NON_MODEL_TABLES = %w(delayed_jobs schema_migrations versions).freeze

  queue_as :default

  def perform
    errors = model_errors

    SystemMailer.error(ERROR_MESSAGE, errors).deliver_later if errors.any?
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
