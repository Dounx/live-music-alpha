class Room < ApplicationRecord
  serialize :playlist, JSON

  belongs_to :user

  validates :url, presence: true, format: { with: %r{(http|https)://} }

  before_create :set_playlist, :generate_token
  after_find :refresh

  def refresh
    update(playlist: fetch_playlist)
  end

  private

  def fetch_playlist
    Api.playlist(playlist_id)
  end

  def playlist_id
    url.scan(/id=(.*)/).last.last
  end

  # before_create
  def set_playlist
    self.playlist = fetch_playlist
  end

  # before_create
  def generate_token
    loop do
      token = SecureRandom.hex(8)
      unless Room.find_by_token(token)
        self.token = token
        break
      end
    end
  end
end
