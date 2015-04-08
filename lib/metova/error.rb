module Metova
  class GenericError
    include ActiveModel::Model

    def initialize(error)
      @error = error
    end

    def errors
      [@error]
    end

  end
end
