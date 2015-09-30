module Metova
  class GenericError
    include ActiveModel::Model

    def initialize(error)
      @error = error
    end

    def errors
      [@error]
    end

    def to_json(*)
      { errors: errors }.to_json
    end
  end
end
