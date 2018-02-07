class SnsNotificationsAPI < ApplicationAPI
  namespace :sns_notifications do
    format :txt

    desc t('.create.description')
    post do
      authorize :sns, :create?
      SnsNotification.from_message(request.body.read)
      status :no_content
    end
  end
end
