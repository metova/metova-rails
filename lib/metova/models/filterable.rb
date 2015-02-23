module Metova
  module Models
    module Filterable
      extend ActiveSupport::Concern

      module ClassMethods
        def filter_attributes(arg = nil)
          @filter_attributes = arg if arg
          @filter_attributes
        end

        def filter(target)
          filter_texts = []
          filter_attributes.each do |attr|
            filter_texts << "#{attr} like ?"
          end
          query = [filter_texts.join(' OR ')]
          filter_texts.count.times { query << "%#{target}%" }
          where(query)
        end
      end
    end
  end
end