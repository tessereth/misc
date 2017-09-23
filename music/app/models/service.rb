class Service < ApplicationRecord
  include ActiveModel::Serializers::JSON
  belongs_to :congregation, optional: true
  has_many :service_songs, -> { order(:position) }
  has_many :songs, through: :service_songs

  def self.from_email(date, body, congregation)
    service = self.find_or_create_by!(date: date, congregation: congregation)
    re = /(tis|at\w\w?) (\d+) (.*)$/i
    nb_re = /NB (.*)$/i
    song_count = 1
    service.service_songs.destroy_all
    body.each_line do |line|
      if m = re.match(line)
        book = Book.find_by!(acronym: m[1].upcase)
        song = Song.find_or_create_by!(book: book, number: m[2]) do |s|
          s.title = m[3].strip
        end
        ServiceSong.create!(song: song, service: service, position: song_count)
        song_count += 1
      elsif m = nb_re.match(line)
        song = Song.find_or_create_by!(title: m[1].strip)
        ServiceSong.create!(song: song, service: service, position: song_count)
        song_count += 1
      end
    end
    return service
  end
end
