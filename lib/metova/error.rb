module Metova
  class Error
    include ActiveModel::Model

    def initialize(message)
      @message = message
    end

    def errors
      [@message]
    end

  end
end