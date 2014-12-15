module Metova
  class Engine < ::Rails::Engine
    isolate_namespace Metova

    require 'kaminari'
    require 'responders'

  end
end
