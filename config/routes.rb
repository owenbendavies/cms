Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/emails' if Rails.env.development?

  root 'systems#home'

  get '/robots', to: 'systems#robots'
  get '/sitemap', to: 'pages#index'

  get '/system/error_500', to: 'systems#error_500'
  get '/system/error_delayed', to: 'systems#error_delayed'
  get '/system/error_timeout', to: 'systems#error_timeout'
  get '/system/health', to: 'systems#health'

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

  resource :site, only: [:edit, :update] do
    match :css, via: [:get, :patch]

    resources :images, only: [:index]
    resources :messages, only: [:index, :show]
    resources :users, only: [:index]
  end

  resources :pages, path: '', only: [:new, :create, :show, :edit, :update, :destroy] do
    member do
      post :contact_form
    end
  end

  match '*path', to: 'application#page_not_found', via: :all
end
