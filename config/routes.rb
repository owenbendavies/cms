Rails.application.routes.draw do
  mount API, at: '/api'

  root to: redirect('/home')

  get '/auth/cognito-idp/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#invalid'

  get '/login', to: redirect('/auth/cognito-idp')
  get '/logout', to: 'sessions#destroy'

  get '/robots', to: 'systems#robots'
  get '/sitemap', to: 'pages#index'

  get '/system/test_500_error', to: 'systems#test_500_error'
  get '/system/test_timeout_error', to: 'systems#test_timeout_error'

  get '/user/sites', to: 'admin/sites#index'

  namespace :admin do
    resource :site, only: %i[edit update]
    resource :stylesheet, only: %i[edit update]
    resources :images, only: %i[index]
  end

  get '/admin/*path', to: 'admin#index', via: :get, as: :admin

  resources :css, only: %i[show]

  resources :pages, path: '', only: %i[new create show edit update destroy] do
    member do
      post :contact_form
    end
  end

  match '*path', to: 'application#page_not_found', via: :all
end
