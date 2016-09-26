class ValidateDataJob < BaseJob
  NON_MODEL_TABLES = %w(delayed_jobs schema_migrations versions).freeze

  def perform
    errors = model_errors

    error(I18n.t('jobs.validate_data_job.error'), errors) if errors.any?
  end

  private

  def models
    all_table_names = ActiveRecord::Base.connection.tables
    model_tables = all_table_names - NON_MODEL_TABLES
    model_tables.sort.map(&:classify).map(&:constantize)
  end

  def model_errors
    models.map do |model|
      model.find_each.reject(&:valid?).map do |record|
        "#{model}##{record.id}: " + record.errors.full_messages.join(', ')
      end
    end.flatten
  end
end
