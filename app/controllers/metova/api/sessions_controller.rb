class Metova::API::SessionsController < ::Devise::SessionsController
  respond_to :json

  def create
    if params[:provider]
      sign_in_with_oauth
    else
      super
    end
  end

  private
    def sign_in_with_oauth
      provider = params[:provider]
      auth = Metova::Oauth::GenericProvider.authenticate provider, params[:access_token], params[:token_secret]
      @identity = Metova::Identity.find_or_initialize_with_omniauth(auth)

      if user = @identity.user
        sign_in_user user
      else
        sign_up_user auth, @identity
      end
    end

    def sign_in_user(user)
      user.reset_authentication_token! if user.token_expired?
      respond_with user, location: nil
    end

    def sign_up_user(auth, identity)
      user = User.new Hash[email: auth.info.email, password: SecureRandom.hex].merge(sign_in_params)
      if user.save and identity.update(user: user)
        sign_in_user user
      else
        respond_with user
      end
    end
end
