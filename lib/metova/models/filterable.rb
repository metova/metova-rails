module Metova
  module Models
    module Filterable
      extend ActiveSupport::Concern

      included do
        scope :filter, ->(target) {
          filter_texts = []
          filter_attributes.each do |attr|
            filter_texts << "#{attr} like ?"
          end
          query = [filter_texts.join(' OR ')]
          filter_texts.count.times{ query << "%#{target}%" }
          where(query)
        }
      end

      module ClassMethods
        def filter_attributes(arg=nil)
          @filter_attributes = arg if arg
          @filter_attributes
        end
      end
    end
  end
end