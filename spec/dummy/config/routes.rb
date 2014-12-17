Rails.application.routes.draw do

  mount Metova::Engine => "/metova"

  namespace :api, defaults: { format: 'json' } do
    version 1 do
      resources :posts
    end
  end

end
