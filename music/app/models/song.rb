class Song < ApplicationRecord
  include ActiveModel::Serializers::JSON
  belongs_to :book
end
