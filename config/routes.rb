Metova::Engine.routes.draw do
  get 's3/presigned_url', to: 's3#presigned_url'
end
