Rails.application.routes.draw do
  mount GrapeSwaggerRails::Engine, at: '/swagger' if Rails.env.development?
  mount API, at: '/api'

  root 'systems#home'

  get '/robots', to: 'systems#robots'
  get '/sitemap', to: 'pages#index'

  get '/system/test_500_error', to: 'systems#test_500_error'
  get '/system/test_timeout_error', to: 'systems#test_timeout_error'

  get '/user/sites', to: 'sites#index'

  devise_for :user, skip: [:sessions], controllers: {
    invitations: 'invitations',
    omniauth_callbacks: 'omniauth_callbacks'
  }

  devise_scope :user do
    get '/user/edit', to: 'devise/registrations#edit', as: 'edit_user_registration'
    patch '/user', to: 'devise/registrations#update', as: 'user_registration'

    get '/login', to: 'devise/sessions#new', as: :new_user_session
    post '/login', to: 'devise/sessions#create', as: :user_session
    get '/logout', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  resource :site, only: %i[edit update] do
    member do
      get :css
    end

    resources :images, only: [:index]
    resources :messages, only: %i[index show]
    resources :users, only: [:index]
  end

  resources :pages, path: '', only: %i[new create show edit update destroy] do
    member do
      post :contact_form
    end
  end

  match '*path', to: 'application#page_not_found', via: :all
end
