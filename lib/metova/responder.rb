module Metova
  class Responder < ActionController::Responder

    prepend Metova::Responders::PaginationResponder
    prepend Metova::Responders::IdsFilterResponder
    prepend Metova::Responders::SortResponder
    include ::Responders::HttpCacheResponder
    include ::Responders::FlashResponder

    def to_format
      validate!
      if errors.any?
        display({ errors: errors })
      else
        super
      end
    end

    def validate!
    end

    private

      def errors
        @_errors ||= []
      end

  end
end