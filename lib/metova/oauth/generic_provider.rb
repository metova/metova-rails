module Metova
  module Oauth
    class GenericProvider
      attr_accessor :access_token, :token_secret, :uid, :provider, :info

      def initialize(access_token, token_secret = nil)
        @access_token = access_token
        @token_secret = token_secret
      end

      def self.authenticate(provider, access_token, token_secret = nil)
        find_provider(provider).new(access_token, token_secret).authenticate
      end

      def name
        'OAuth'
      end

      private
        def self.find_provider(provider)
          map = {
            twitter: Metova::Oauth::TwitterProvider,
            facebook: Metova::Oauth::FacebookProvider,
            google_oauth2: Metova::Oauth::GoogleProvider,
            flux: Metova::Oauth::FluxProvider
          }

          map.fetch provider.to_sym
        end

        def me(&block)
          yield
          # rescue errors
        end
    end
  end
end
