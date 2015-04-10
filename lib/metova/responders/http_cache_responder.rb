module Metova
  module Responders
    module HttpCacheResponder

      def initialize(*)
        super
        @_cache = options.delete :cache
      end

      def to_json
        return if http_cache? and http_cache!
        to_format
      end

      private
        def http_cache?
          get? and persisted? and ActionController::Base.perform_caching and
            resource.respond_to?(:cache_key) and (@_cache != false) and
            controller.params[:cache] != false
        end

        def http_cache!
          controller.fresh_when resource
        end

        def persisted?
          resource.respond_to?(:persisted?) ? resource.persisted? : true
        end
    end
  end
end
