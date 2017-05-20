class ValidateDataJob < ApplicationJob
  def perform
    MODELS.each do |model|
      model.find_each.reject(&:valid?).each do |record|
        error("#{model}##{record.id}: #{record.errors.full_messages.join(', ')}")
      end
    end
  end
end
