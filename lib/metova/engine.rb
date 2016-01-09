module Metova
  class Engine < ::Rails::Engine
    isolate_namespace Metova

    # require 'kaminari'
    require 'devise'
    require 'responders'

  end
end
