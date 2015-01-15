module Metova
  class Engine < ::Rails::Engine
    isolate_namespace Metova

    require 'kaminari'
    require 'devise'
    require 'responders'
    require 'faraday'
    require 'faraday_middleware'

  end
end
