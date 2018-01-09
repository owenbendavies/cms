# == Schema Information
#
# Table name: sns_notifications
#
#  id         :integer          not null, primary key
#  message    :json             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SnsNotification < ApplicationRecord
  def self.from_message(raw_message)
    verify_message(raw_message)
    notification = create!(message: JSON.parse(raw_message))

    notification.confirm_subscription if notification.type == 'SubscriptionConfirmation'
    notification
  end

  def confirm_subscription
    arn = message.fetch('TopicArn')
    token = message.fetch('Token')

    Aws::SNS::Topic.new(arn: arn, client: AWS_SNS_CLIENT).confirm_subscription(token: token)
  end

  def type
    message.fetch('Type')
  end

  private_class_method

  def self.verify_message(raw_message)
    Aws::SNS::MessageVerifier.new.authenticate!(raw_message)
  end
end
