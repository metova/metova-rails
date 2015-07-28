Rails.application.routes.draw do

  mount Metova::Engine => "/metova"

  devise_for :users,
    path_names: { sign_in: 'login', sign_out: 'logout' },
    controllers: { omniauth_callbacks: 'metova/omniauth_callbacks', registrations: 'metova/registrations' }

  resources :posts, only: :index
  root to: 'posts#index'

  namespace :api, defaults: { format: 'json' } do
    devise_for :users,
      path_names: { sign_in: 'login', sign_out: 'logout' },
      controllers: { sessions: 'metova/api/sessions' }

    version 1 do
      resources :posts do
        get :secret, on: :collection
      end
    end
  end

end
