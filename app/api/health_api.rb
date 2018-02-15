class HealthAPI < ApplicationAPI
  namespace :health do
    desc t('.description'), success: Entities::SystemHealth
    get do
      authorize :health, :status?
      status = { status: 'ok' }
      present status, with: Entities::SystemHealth
    end
  end
end
