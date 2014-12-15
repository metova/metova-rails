class Api::BaseController < ApplicationController

  respond_to :json
  self.responder = Metova::Responder

end