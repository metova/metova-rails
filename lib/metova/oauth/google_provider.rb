module Metova
  module Oauth
    class GoogleProvider < GenericProvider
      GOOGLE_API_URL = 'https://www.googleapis.com/plus/v1/people/me'
      ME_URL = -> (token) { "#{GOOGLE_API_URL}/me?access_token=#{token}" }

      def authenticate
        self.info = OmniAuth::AuthHash.new me
        self.uid = info.id
        self
      end

      def name
        'Google'
      end

      def provider
        :google_oauth2
      end

      def me
        super do
          client = OAuth2
          token = OAuth2::AccessToken.new
          JSON.parse URI.parse(ME_URL[access_token]).read
        end
      end
    end
  end
end
