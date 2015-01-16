Rails.application.routes.draw do
  root 'application#home'

  devise_for :users, skip: [:sessions]

  devise_scope :user do
    get 'login', to: 'devise/sessions#new', as: :new_user_session
    post 'login', to: 'devise/sessions#create', as: :user_session
    get 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  if Rails.application.secrets.loaderio_token
    get Rails.application.secrets.loaderio_token, to: 'loaderios#show'
  end

  get 'timeout', to: 'test_routes#timeout'

  resource :registrations, only: [:edit, :update], path: 'user' do
    get :sites
  end

  resource :health, only: [:show]

  resource :robots, only: [:show]

  resource :site, only: [:edit, :update] do
    match :css, via: [:get, :patch]

    resources :images, only: [:index]
    resources :messages, only: [:index, :show]
    resources :users, only: [:index]
  end

  resource :sitemap, only: [:show]

  resources(
    :pages,
    path: '',
    only: [:new, :create, :show, :edit, :update, :destroy]
  ) do
    member do
      post :contact_form
    end
  end

  match '*path', to: 'application#page_not_found', via: :all
end
