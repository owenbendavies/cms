class SnsNotificationsAPI < Grape::API
  namespace :sns_notifications do
    ENTITY = Entities::SnsNotification

    desc 'SNS Notifications', success: ENTITY

    post do
      authorize :sns, :create?
      sns = SnsNotification.from_message(request.body.read)
      present sns, with: ENTITY
    end
  end
end
