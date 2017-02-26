class Service < ApplicationRecord
  include ActiveModel::Serializers::JSON
  has_many :service_songs
  has_many :songs, through: :service_songs

  def self.from_email(date, body)
    service = self.find_or_create_by!(date: date)
    re = /(tis|at\w\w?) (\d+) (.*)$/i
    nb_re = /NB (.*)$/i
    song_count = 1
    service.service_songs.destroy_all
    body.each_line do |line|
      if m = re.match(line)
        book = Book.find_by!(acronym: m[1].upcase)
        song = Song.find_or_create_by!(book: book, number: m[2]) do |s|
          s.title = m[3]
        end
        ServiceSong.create!(song: song, service: service, position: song_count)
        song_count += 1
      elsif m = nb_re.match(line)
        song = Song.find_or_create_by!(title: m[1])
        ServiceSong.create!(song: song, service: service, position: song_count)
        song_count += 1
      end
    end
    return service
  end
end
