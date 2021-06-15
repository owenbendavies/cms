class ValidateDataJob < ApplicationJob
  NON_MODEL_TABLES = %w[ar_internal_metadata schema_migrations versions].freeze

  private_constant :NON_MODEL_TABLES

  def perform
    models.each do |model|
      model.find_each.reject(&:valid?).each do |record|
        report_error(record)
      end
    end
  end

  private

  def report_error(record)
    error(
      'found invalid model',
      model_class: record.class.name,
      model_id: record.id,
      model_errors: record.errors.full_messages
    )
  end

  def models
    tables = ActiveRecord::Base.connection.tables

    (tables - NON_MODEL_TABLES).map { |table| table.classify.constantize }
  end
end
