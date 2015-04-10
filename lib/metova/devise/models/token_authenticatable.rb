require 'devise'

module Devise
  module Models
    module TokenAuthenticatable
      extend ActiveSupport::Concern

      included do
        before_save :ensure_authentication_token!
      end

      def self.required_fields(klass)
        [:authentication_token, :token_expires_at]
      end

      def reset_authentication_token
        self.authentication_token = loop do
          token = Devise.friendly_token
          break token unless self.class.exists?(authentication_token: token)
        end
        self.token_expires_at = Time.current + expire_token_in
      end

      def reset_authentication_token!
        reset_authentication_token
        save validate: false
      end

      def ensure_authentication_token!
        reset_authentication_token! if authentication_token.blank? || token_expired?
      end

      def token_expired?
        token_expires_at.nil? || token_expires_at.past?
      end

      def expire_token_in
        14.days
      end
    end
  end
end
