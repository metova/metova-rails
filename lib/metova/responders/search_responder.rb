module Metova
  module Responders
    module SearchResponder

      def initialize(*)
        super
        @resource = search(@resource, query) if searching?
      end

      private
        def search(resource, query = {})
          if fuzzy?
            resource.fuzzy_search query, exclusive?
          else
            resource.basic_search query, exclusive?
          end
        end

        def searching?
          controller.params.include?(:search) && controller.params[:search].is_a?(Hash)
        end

        def query
          controller.params[:search][:query]
        end

        def fuzzy?
          controller.params[:search][:_fuzzy] == '1'
        end

        def exclusive?
          if controller.params[:search][:_operator] =~ /OR/i
            false
          else
            true
          end
        end
    end
  end
end

Metova::Responder.send :prepend, Metova::Responders::SearchResponder
