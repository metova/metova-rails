module Metova
  module Versioning
    class Constraints

      def initialize(version)
        @version = version
      end

      def matches?(request)
        (@version == 1 && no_version_was_sent?(request)) || current_version_matches_the_version_sent?(request)
      end

      private

        def no_version_was_sent?(request)
          !request.headers['Accept'].include?('version=')
        end

        def current_version_matches_the_version_sent?(request)
          request.headers['Accept'] =~ /version=#{@version}\z/i
        end

    end
  end
end