class TestErrorsAPI < ApplicationAPI
  namespace :test_errors do
    desc t('.500.description')
    get '500' do
      authorize :test_errors, :error_500?
      raise 'Test 500 error'
    end

    desc t('.delayed.description')
    get :delayed do
      authorize :test_errors, :error_delayed?
      Kernel.delay(queue: 'default').fail('Test delayed error')
      { 'message' => 'Delayed error sent' }
    end

    desc t('.timeout.description')
    get :timeout do
      authorize :test_errors, :error_timeout?
      sleep Rack::Timeout.service_timeout + 1
    end
  end
end
