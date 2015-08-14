Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/emails'
    mount PgHero::Engine, at: '/database'
  end

  root 'systems#home'

  if Rails.application.secrets.loaderio_token
    get Rails.application.secrets.loaderio_token, to: 'systems#loader_io'
  end

  get '/health', to: 'systems#health'
  get '/robots', to: 'systems#robots'
  get '/sitemap', to: 'systems#sitemap'
  get '/timeout', to: 'systems#timeout'

  devise_for :user, skip: [:sessions], controllers: { invitations: 'invitations' }

  devise_scope :user do
    get '/login', to: 'devise/sessions#new', as: :new_user_session
    post '/login', to: 'devise/sessions#create', as: :user_session
    get '/logout', to: 'devise/sessions#destroy', as: :destroy_user_session

    get '/user/edit', to: 'devise/registrations#edit', as: 'edit_user_registration'
    patch '/user', to: 'devise/registrations#update', as: 'user_registration'
  end

  resource :site, only: [:edit, :update] do
    match :css, via: [:get, :patch]

    resources :images, only: [:index]
    resources :messages, only: [:index, :show]
    resources :users, only: [:index]
  end

  resources :sites, only: [:index]

  resources :pages, path: '', only: [:new, :create, :show, :edit, :update, :destroy] do
    member do
      post :contact_form
    end
  end

  match '*path', to: 'application#page_not_found', via: :all
end
