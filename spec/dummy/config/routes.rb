Rails.application.routes.draw do

  mount Metova::Engine => "/metova"

  namespace :api, defaults: { format: 'json' } do
    resources :posts
  end

end
