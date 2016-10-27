class ValidateDataJob < ApplicationJob
  NON_MODEL_TABLES = %w(delayed_jobs schema_migrations versions).freeze

  def perform
    models.each do |model|
      model.find_each.reject(&:valid?).each do |record|
        error("#{model}##{record.id}: " + record.errors.full_messages.join(', '))
      end
    end
  end

  private

  def models
    all_table_names = ActiveRecord::Base.connection.tables
    model_tables = all_table_names - NON_MODEL_TABLES
    model_tables.sort.map(&:classify).map(&:constantize)
  end
end
