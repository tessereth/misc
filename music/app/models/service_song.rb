class ServiceSong < ApplicationRecord
  belongs_to :song
  belongs_to :service
end
