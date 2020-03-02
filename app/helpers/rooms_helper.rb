module RoomsHelper
  def share_url(room)
    "#{join_rooms_url}?token=#{room.token}"
  end
end
