module Metova
  module Responders
    module IdsFilterResponder

      def initialize(*)
        super
        @resource = filter_ids(@resource) if response_should_be_filtered?
      end

      private
        def filter_ids(resource)
          resource.where(id: ids)
        end

        def response_should_be_filtered?
          controller.params.include?(:ids)
        end

        def ids
          controller.params[:ids].split(',')
        end
    end
  end
end
