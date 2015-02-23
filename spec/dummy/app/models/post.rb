class Post < ActiveRecord::Base
  include Metova::Models::Filterable
  belongs_to :user
  filter_attributes %w(title body)
end
