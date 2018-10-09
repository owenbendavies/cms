class DeleteOldModelsJob < ApplicationJob
  def perform
    delete_old_models('messages', Message)
    delete_old_models('versions', PaperTrail::Version.where.not(item_type: 'Page'))
  end

  private

  def delete_old_models(name, models)
    old_models = models.where('created_at < ?', 30.days.ago)
    count = old_models.count
    return unless count.positive?

    old_models.delete_all
    info "deleted #{count} #{name}"
  end
end
