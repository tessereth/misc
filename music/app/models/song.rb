class Song < ApplicationRecord
  include ActiveModel::Serializers::JSON
  belongs_to :book, optional: true
  has_many :service_songs
  has_many :services, through: :service_songs
end
