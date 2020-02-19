class Room < ApplicationRecord
  serialize :playlist, JSON

  belongs_to :user

  validates :url, presence: true, format: { with: %r{(http|https)://} }
  validates :token, presence: true, uniqueness: true

  before_save :fetch_playlist, :generate_token

  private

  def fetch_playlist
    prefix = 'http://127.0.0.1:4000/playlist/detail?id='
    api = URI.parse(prefix + playlist_id)
    res = Net::HTTP.get(api)
    self.playlist = format(JSON.parse(res))
  end

  def playlist_id
    url.scan(/id=(.*)/).last.last
  end

  def format(json)
    json['playlist']['tracks'].map do |song|
      id = song['id']
      {
        id: id,
        name: song['name'],
        pic_url: song['al']['picUrl']
      }
    end
  end

  def generate_token
    token = SecureRandom.hex(8)
    token = SecureRandom.hex(8) while Room.find_by_token(token)
    self.token = token
  end
end
