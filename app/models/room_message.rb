class RoomMessage < Message
  def deliver
    room = Room.find(to)
    RoomsChannel.broadcast_to(room, data)
  end
end