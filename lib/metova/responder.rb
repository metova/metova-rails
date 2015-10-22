module Metova
  class Responder < ActionController::Responder

    prepend Metova::Responders::PaginationResponder
    prepend Metova::Responders::IdsFilterResponder
    prepend Metova::Responders::SortResponder
    prepend Metova::Responders::NestedAssociationResponder
    prepend Metova::Responders::DisplayResourceOnPutDeleteResponder
    include Metova::Responders::HttpCacheResponder
    include ::Responders::FlashResponder

    def initialize(*)
      super
      options[:location] = nil if format == :json
    end

    def to_format
      validate!
      if errors.any?
        display({ errors: errors }, status: 400)
      else
        super
      end
    end

    def validate!
    end

    def json_resource_errors
      { errors: resource.errors.full_messages }
    end

    private
      def errors
        @_errors ||= []
      end
  end
end
