module Metova
  module Oauth
    class TwitterProvider < GenericProvider
      TWITTER_SITE_URL = 'https://api.twitter.com'
      TWITTER_API_URL = 'https://api.twitter.com/1.1'
      ME_URL = "#{TWITTER_API_URL}/account/verify_credentials.json?include_entities=false&skip_status=true"

      def authenticate
        self.info = OmniAuth::AuthHash.new me
        self.uid = info.id
        self
      end

      def name
        'Twitter'
      end

      def provider
        :twitter
      end

      private
        def me
          super do
            JSON.parse(oauth_access_token.get(ME_URL).body)
          end
        end

        def oauth_access_token
          OAuth::AccessToken.from_hash consumer, oauth_token: access_token, oauth_token_secret: token_secret
        end

        def consumer
          @consumer ||= begin
            OAuth::Consumer.new(ENV['TWITTER_APP_ID'], ENV['TWITTER_APP_SECRET'], site: TWITTER_SITE_URL, scheme: :header)
          end
        end
    end
  end
end
