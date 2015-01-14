require 'devise'

module Devise
  module Strategies
    class TokenAuthenticatable < Base

      def authenticate!
        user  = User.find_by(authentication_token: token)
        if user.present?
          success! user
        else
          fail! 'Invalid authentication token'
        end
      end

      def valid?
        token.present?
      end

      private

        def token
          @_token ||= ActionController::HttpAuthentication::Token.token_and_options(request)
        end

    end
  end
end