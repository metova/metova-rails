module Metova
  module Responders
    module ErrorResponder

      def initialize(*)
        super
        if has_errors?
          Rails.logger.error "Response failed with error(s): #{@resource.errors.full_messages.to_sentence}"
        end
      end

    end
  end
end