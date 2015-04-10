module Metova
  module Responders
    module SortResponder

      def initialize(*)
        super
        @resource = sort(@resource) if response_should_be_sorted?
      end

      private
        def sort(resource)
          resource.order(field_to_order_by => direction)
        end

        def response_should_be_sorted?
          controller.params.include?(:sort)
        end

        def field_to_order_by
          controller.params[:sort]
        end

        def direction
          controller.params.fetch(:direction, :asc)
        end
    end
  end
end
