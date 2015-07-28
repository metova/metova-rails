module Metova
  class Identity < ActiveRecord::Base
    belongs_to :user, required: true

    validates :uid, :provider, presence: true

    def self.find_or_initialize_with_omniauth(auth)
      find_or_initialize_by uid: auth.uid, provider: auth.provider
    end
  end
end
