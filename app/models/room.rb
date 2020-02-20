class Room < ApplicationRecord
  serialize :playlist, JSON

  belongs_to :user

  validates :url, presence: true, format: { with: %r{(http|https)://} }
  validates :token, presence: true, uniqueness: true

  before_create :set_playlist, :generate_token

  def refresh
    update(playlist: fetch_playlist)
  end

  private

  def fetch_playlist
    prefix = 'http://127.0.0.1:4000/playlist/detail?id='
    api = URI.parse(prefix + playlist_id)
    res = Net::HTTP.get(api)
    format(JSON.parse(res))
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
        artist: song['ar'].map { |ar| ar['name'] }.join(' '),
        cover: song['al']['picUrl']
      }
    end
  end

  # before_create
  def set_playlist
    self.playlist = fetch_playlist
  end

  # before_create
  def generate_token
    token = SecureRandom.hex(8)
    token = SecureRandom.hex(8) while Room.find_by_token(token)
    self.token = token
  end
end
