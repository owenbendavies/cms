class SnsNotificationsAPI < ApplicationAPI
  format :txt

  namespace :sns_notifications do
    post do
      authorize :sns, :create?
      SnsNotification.from_message(request.body.read)
      status :no_content
    end
  end
end
