module Metova
  module Versioning
    module RouterDSL

      def version(version, &block)
        scope constraints: Metova::Versioning::Constraints.new(version), &block
        match '(*catchall)', to: UnsupportedVersionApp.new, via: [:get, :post, :put, :delete]
      end

    end
  end
end