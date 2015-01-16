module Metova
  module Devise
    module Controller
      extend ActiveSupport::Concern

      included do
        respond_to :json
        self.responder = Metova::Responder
      end

      def devise_mapping
        @_devise_mapping ||= ::Devise.mappings[super.singular.to_s.gsub('api_', '').intern]
      end

    end
  end
end