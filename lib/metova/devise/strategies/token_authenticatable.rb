require 'devise'

module Devise
  module Strategies
    class TokenAuthenticatable < Base

      def authenticate!
        user = mapping.to.find_by(email: options[:email])
        if user && valid_token?(user)
          success! user
        else
          fail! 'Invalid authentication token'
        end
      end

      def valid?
        token.present? && options.include?(:email)
      end

      private

        def valid_token?(user)
          Devise.secure_compare user.authentication_token, token
        end

        def token
          @_token ||= token_and_options[0]
        end

        def options
          @_options ||= token_and_options[1]
        end

        def token_and_options
          @_token_and_options ||= ActionController::HttpAuthentication::Token.token_and_options(request)
        end

    end
  end
end