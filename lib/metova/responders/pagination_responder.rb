module Metova
  module Responders
    module PaginationResponder

      def initialize(*)
        super
        @resource = paginate(@resource) if response_should_be_paginated?
      end

      def validate!
        if controller.params.include?(:page) && !controller.params.include?(:per_page)
          errors << "'page' param sent without 'per_page'"
        elsif controller.params.include?(:per_page) && !controller.params.include?(:page)
          errors << "'per_page' param sent without 'page'"
        end
        super
      end

      private

        def paginate(resource)
          resource.page(controller.params[:page]).per(controller.params[:per_page])
        end

        def response_should_be_paginated?
          controller.params.include?(:page) &&
            controller.params.include?(:per_page)
        end

    end
  end
end