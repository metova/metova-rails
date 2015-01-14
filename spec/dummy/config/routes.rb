Rails.application.routes.draw do

  mount Metova::Engine => "/metova"

  namespace :api, defaults: { format: 'json' } do
    devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout' }

    version 1 do

      resources :posts do
        get :secret, on: :collection
      end

    end
  end

end
