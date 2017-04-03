class Congregation < ApplicationRecord
  include ActiveModel::Serializers::JSON
  has_many :services
end
