class Metova::OmniauthCallbacksController < ::Devise::OmniauthCallbacksController

  PROVIDERS = [
    :flux,
    :twitter,
    :facebook,
    :google_oauth2,
    :instagram
  ]

  def all
    @identity = Metova::Identity.find_or_initialize_with_omniauth auth
    if signed_in?
      attach_identity_to_user @identity, current_user
    else
      sign_in_or_sign_up_with_identity @identity
    end
  end

  # redirect each provider to the "all" method
  PROVIDERS.each do |provider|
    define_method(provider) { all }
  end

  private
    def auth
      @_auth ||= request.env['omniauth.auth']
    end

    def attach_identity_to_user(identity, user)
      if identity.user == user
        redirect_with_notification 'You are already linked with this account.'
      else
        identity.update user: user
        redirect_with_notification 'Successfully linked your account.'
      end
    end

    def sign_in_or_sign_up_with_identity(identity)
      if identity.user.present?
        sign_in_and_redirect :user, identity.user
      else
        sign_up_user auth, identity
      end
    end

    def sign_up_user(auth, identity)
      user = User.new email: auth.info.email, password: SecureRandom.hex
      if user.save and identity.update(user: user)
        sign_in_and_redirect :user, identity.user
      else
        save_oauth_session_data_and_prompt_user_to_complete_registration(auth)
      end
    end

    def save_oauth_session_data_and_prompt_user_to_complete_registration(auth)
      session[:omniauth] = auth.except 'extra'
      redirect_to after_invalid_user_sign_up_path
    end

    def redirect_with_notification(notification, path: after_successful_omniauth_path)
      redirect_to path, notice: notification
    end

    def after_invalid_user_sign_up_path
      main_app.new_user_registration_path
    end

    def after_successful_omniauth_path
      main_app.root_path
    end
end
