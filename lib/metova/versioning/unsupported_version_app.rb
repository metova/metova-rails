module Metova
  module Versioning
    class UnsupportedVersionApp

      def call(env)
        [
          412,
          { 'Content-Type' => 'application/json' },
          JSON[{ errors: ['API version was not provided or is not current. Provide the API version in the Accept header (Accept: application/json; version=X)'] }]
        ]
      end

    end
  end
end