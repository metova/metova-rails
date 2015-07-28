class Metova::RegistrationsController < ::Devise::RegistrationsController

  def create
    super
    session[:omniauth] = nil if resource.persisted?
  end

  private
    def build_resource(*args)
      super
      if omniauth = session[:omniauth]
        set_omniauth_attributes_on_user omniauth
        resource.identities.build provider: omniauth['provider'], uid: omniauth['uid']
      end
    end

    helper_method \
    def has_omniauth_session_data?
      session[:omniauth].present?
    end

    def set_omniauth_attributes_on_user(omniauth)
      resource.email ||= omniauth['info']['email']
    end
end
