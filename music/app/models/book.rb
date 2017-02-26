class Book < ApplicationRecord
  include ActiveModel::Serializers::JSON
  has_many :songs, -> { order(:number) }
end
