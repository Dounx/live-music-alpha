class Api
  class << self
    def playlist(id)
      api = URI.parse(NeteaseApi::PLAYLIST + id)
      res = Net::HTTP.get(api)
      format_for_playlist(JSON.parse(res))
    end

    def lrc(id)
      api = URI.parse(NeteaseApi::LRC + id)
      res = Net::HTTP.get(api)
      data = JSON.parse(res)['lrc']&.fetch('lyric')
      data&.squish
    end

    private

    def format_for_playlist(json)
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
  end
end