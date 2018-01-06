class HealthAPI < Grape::API
  get :health do
    authorize :health, :status?
    { 'status' => 'ok' }
  end
end
