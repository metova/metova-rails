module Metova
  module Oauth
    class FluxProvider < GenericProvider
      FLUX_API_URL = 'https://id.fluxhq.io/api/v1'
      ME_URL = -> (token) { "#{FLUX_API_URL}/me?access_token=#{token}" }

      def authenticate
        self.info = OmniAuth::AuthHash.new me
        self.uid = info.id
        self
      end

      def name
        'FluxID'
      end

      def provider
        :flux
      end

      def me
        super do
          JSON.parse URI.parse(ME_URL[access_token]).read
        end
      end
    end
  end
end
