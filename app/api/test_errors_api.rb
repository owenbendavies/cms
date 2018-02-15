class TestErrorsAPI < ApplicationAPI
  namespace :test_errors do
    desc t('.500.description'), success: { code: 500, model: Entities::SystemError }
    get '500' do
      authorize :test_errors, :error_500?
      raise 'Test 500 error'
    end

    desc t('.delayed.description'), success: { code: 202, model: Entities::SystemMessage }
    get :delayed do
      authorize :test_errors, :error_delayed?
      Kernel.delay(queue: 'default').fail('Test delayed error')
      message = { message: 'Delayed error sent' }
      status 202
      present message, with: Entities::SystemMessage
    end

    desc t('.timeout.description')
    get :timeout do
      authorize :test_errors, :error_timeout?
      sleep Rack::Timeout.service_timeout + 1
    end
  end
end
