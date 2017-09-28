class ValidateDataJob < ApplicationJob
  NON_MODEL_TABLES = %w[ar_internal_metadata delayed_jobs schema_migrations versions].freeze

  def perform
    models.each do |model|
      model.find_each.reject(&:valid?).each do |record|
        error("#{model}##{record.id}: #{record.errors.full_messages.join(', ')}")
      end
    end
  end

  private

  def models
    tables = ActiveRecord::Base.connection.tables

    (tables - NON_MODEL_TABLES).map { |table| table.classify.constantize }
  end
end
