require 'metova'
require 'open-uri'

require 'metova/oauth/generic_provider'
require 'metova/oauth/facebook_provider'
require 'metova/oauth/twitter_provider'
require 'metova/oauth/flux_provider'
require 'metova/oauth/google_provider'

require 'metova/oauth/error/devise_not_configured'

begin
  require 'omniauth'
rescue LoadError
  raise "You've required metova/oauth but don't have omniauth! Install an omniauth provider first (ex: gem 'omniauth-twitter')"
end
