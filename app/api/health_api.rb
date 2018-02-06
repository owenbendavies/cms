class HealthAPI < ApplicationAPI
  get :health do
    authorize :health, :status?
    { 'status' => 'ok' }
  end
end
