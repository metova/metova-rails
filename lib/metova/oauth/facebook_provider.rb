module Metova
  module Oauth
    class FacebookProvider < GenericProvider
      FACEBOOK_API_URL = 'https://graph.facebook.com/v2.3'
      ME_URL = -> (token) { "#{FACEBOOK_API_URL}/me?access_token=#{token}" }

      def authenticate
        self.info = OmniAuth::AuthHash.new me
        self.uid = info.id
        self
      end

      def provider
        :facebook
      end

      private
        def me
          super do
            JSON.parse URI.parse(ME_URL[access_token]).read
          end
        end
    end
  end
end
