class DeleteOldVersionsJob < ApplicationJob
  def perform
    old_models = PaperTrail::Version.where('created_at < ?', 30.days.ago).where.not(item_type: 'Page')

    return unless old_models.count.positive?

    old_models.delete_all
  end
end
