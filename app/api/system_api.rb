class SystemAPI < ApplicationAPI
  namespace :system do
    desc t('.health.description'), success: Entities::SystemHealth
    get 'health' do
      authorize :system, :health?
      status = {}
      present status, with: Entities::SystemHealth
    end

    desc t('.test_500_error.description') do
      success code: 500, model: Entities::SystemError
    end
    get :test_500_error do
      authorize :system, :test_500_error?
      raise 'Test 500 error'
    end

    desc t('.test_delayed_error.description') do
      success code: 202, model: Entities::SystemMessage
    end
    get :test_delayed_error do
      authorize :system, :test_delayed_error?
      Kernel.delay(queue: 'default').fail('Test delayed error')
      message = { message: 'Delayed error sent' }
      status 202
      present message, with: Entities::SystemMessage
    end

    desc t('.test_timeout_error.description')
    get :test_timeout_error do
      authorize :system, :test_timeout_error?
      sleep 30
    end
  end
end
