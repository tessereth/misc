class Book < ApplicationRecord
  include ActiveModel::Serializers::JSON
  has_many :songs
end
