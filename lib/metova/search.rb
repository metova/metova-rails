require 'metova'
require 'metova/responders/search_responder'

begin
  require 'textacular'
rescue LoadError
  raise "You've required metova/search but don't have textacular! Install textacular first (gem 'textacular')"
end
