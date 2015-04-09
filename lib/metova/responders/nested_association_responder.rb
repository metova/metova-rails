module Metova
  module Responders
    module NestedAssociationResponder

      def initialize(*)
        super
        if @controller.params[:include]
          @options[:include] = @controller.params[:include]
        end
      end

    end
  end
end
