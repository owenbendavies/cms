# == Schema Information
#
# Table name: sns_notifications
#
#  id         :integer          not null, primary key
#  message    :json             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :sns_notification do
    transient do
      message_file 'subscription_confirmation.json'
    end

    message do
      JSON.parse(Rails.root.join('spec', 'assets', 'sns', message_file).read)
    end
  end
end
