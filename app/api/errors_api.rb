class ErrorsAPI < ApplicationAPI
  namespace :errors do
    get '500' do
      authorize :errors, :error_500?
      raise 'Test 500 error'
    end

    get :delayed do
      authorize :errors, :error_delayed?
      Kernel.delay(queue: 'default').fail('Test delayed error')
      { 'message' => 'Delayed error sent' }
    end

    get :timeout do
      authorize :errors, :error_timeout?
      sleep Rack::Timeout.service_timeout + 1
    end
  end
end
