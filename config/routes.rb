Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?

  root to: redirect('/home')

  post '/graphql', to: 'graphql#execute'

  get '/auth/cognito-idp/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#invalid'

  get '/login', to: redirect('/auth/cognito-idp')
  get '/logout', to: 'sessions#destroy'

  get '/robots', to: 'robots#show'
  get '/sitemap', to: 'pages#index'

  namespace :admin do
    resource :stylesheet, only: %i[edit update]
    resources :images, only: %i[index]
  end

  get '/admin', to: 'admin#index'

  resources :css, only: %i[show]

  resources :pages, path: '', only: %i[new create show edit update] do
    member do
      post :contact_form
    end
  end

  match '*path', to: 'application#page_not_found', via: :all
end
