class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :omniauthable, omniauth_providers: [:twitter]

  has_many :posts
  has_many :identities, class_name: 'Metova::Identity'

  def password_required?
    super and (identities.none? or password.present?)
  end

end
