class HealthAPI < ApplicationAPI
  namespace :health do
    desc t('.description')
    get do
      authorize :health, :status?
      { 'status' => 'ok' }
    end
  end
end
