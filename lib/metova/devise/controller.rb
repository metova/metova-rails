module Metova
  module Devise
    module Controller
      extend ActiveSupport::Concern

      included do
        respond_to :json
        self.responder = Metova::Responder
      end

      def devise_mapping
        _super = super
        @_devise_mapping ||= ::Devise.mappings[_super.singular.to_s.gsub('api_', '').intern] || _super
      end

    end
  end
end