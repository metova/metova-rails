module Metova
  module Responders
    module PaginationResponder

      def initialize(*)
        super
        if response_should_be_paginated?
          @resource = paginate(@resource)
          @links = []
          add_next_to_link_header
          add_last_to_link_header
        end
      end

      def validate!
        if controller.params.include?(:page) && !controller.params.include?(:limit)
          errors << "The 'page' param was sent without 'limit'"
        elsif controller.params.include?(:limit) && !controller.params.include?(:page)
          errors << "The 'limit' param was sent without 'page'"
        end
        super
      end

      private

        def paginate(resource)
          resource.page(current_page).per(controller.params[:limit])
        end

        def response_should_be_paginated?
          controller.params.include?(:page) &&
            controller.params.include?(:limit)
        end

        def add_next_to_link_header
          page = current_page + 1
          add_to_link_header 'next', page if page <= last_page.to_i
        end

        def add_last_to_link_header
          add_to_link_header 'last', last_page if last_page
        end

        def add_to_link_header(rel, page)
          url = controller.url_for(request.params.merge(page: page))
          @links << %Q[<#{url}>; rel="#{rel}"]
          controller.response.headers['Link'] = @links.join(', ')
        end

        def current_page
          @_current_page ||= controller.params[:page].to_i
        end

        def last_page
          @_last_page ||= @resource.total_pages
        end

    end
  end
end