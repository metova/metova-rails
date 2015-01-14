require 'devise'

module Devise
  module Models
    module TokenAuthenticatable
      extend ActiveSupport::Concern

      included do
        before_save :ensure_authentication_token!
      end

      def self.required_fields(klass)
        [:authentication_token]
      end

      def reset_authentication_token
        self.authentication_token = loop do
          token = SecureRandom.hex(20)
          break token unless self.class.exists?(authentication_token: token)
        end
      end

      def reset_authentication_token!
        reset_authentication_token
        save validate: false
      end

      def ensure_authentication_token!
        reset_authentication_token! if authentication_token.blank?
      end

    end
  end
end