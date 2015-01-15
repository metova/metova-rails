Metova::Engine.routes.draw do
  resource :feedback, only: [:new, :create, :show]
end
