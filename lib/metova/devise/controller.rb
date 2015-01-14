module Metova
  module Devise
    module Controller
      extend ActiveSupport::Concern

      included do
        respond_to :json
        before_action :accept_user_param_root!
        self.responder = Metova::Responder
      end

      def accept_user_param_root!
        params[:api_user] = params[:user] if params[:user] && !params[:api_user]
      end

    end
  end
end