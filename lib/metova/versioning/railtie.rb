module Metova
  module Versioning
    class Railtie < Rails::Railtie

      initializer 'metova.versioning.configure' do |app|
        ActionDispatch::Routing::Mapper.send :include, Metova::Versioning::RouterDSL
      end

    end
  end
end