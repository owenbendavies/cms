Cms::Application.routes.draw do
  root 'application#home'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  get 'sitemap', to: 'sitemap#show'
  get 'robots', to: 'robots#show'

  if ENV['LOADERIO_VERIFICATION_TOKEN']
    get ENV['LOADERIO_VERIFICATION_TOKEN'], to: 'loaderios#show'
  end

  if ENV['TEST_ROUTES']
    get 'timeout', to: 'test_routes#timeout'
  end

  resource :account, only: [:edit, :update] do
    get :sites
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
