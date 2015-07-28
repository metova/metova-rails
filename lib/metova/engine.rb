module Metova
  class Engine < ::Rails::Engine
    isolate_namespace Metova

    require 'kaminari'
    require 'devise'
    require 'responders'

    # run engine migrations when running bin/rake db:migrate from the main app
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end
    end

  end
end
