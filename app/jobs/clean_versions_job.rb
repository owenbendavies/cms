class CleanVersionsJob < ApplicationJob
  def perform
    old_versions = PaperTrail::Version.where('created_at < ?', 30.days.ago)
                                      .where.not(item_type: 'Page')

    Rails.logger.info "#{self.class} deleted #{old_versions.count}"

    old_versions.delete_all
  end
end
