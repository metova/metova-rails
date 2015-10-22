module Metova
  module Responders
    module DisplayResourceOnPutDeleteResponder

      def api_behavior
        if display_resource_on_put_and_delete? && put_or_delete?
          display resource
        else
          super
        end
      end

      private
        def display_resource_on_put_and_delete?
          controller.try :display_resource_on_put_and_delete?
        end

        def put_or_delete?
          put? || delete?
        end
    end
  end
end
