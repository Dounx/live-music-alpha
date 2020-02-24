class RoomsChannel < ApplicationCable::Channel
  def subscribed
    RoomsChannel.broadcast_to(@room, "#{current_user.email} joined!")
    @room = Room.find(params[:id])
    stream_for @room
  end

  def unsubscribed
    RoomsChannel.broadcast_to(@room, "#{current_user.email} exited!")
    # @room.destroy if @room.user == current_user
  end

  # data
  # {
  #   paused: false,
  #   id: 0,
  #   time: 21345
  # }
  def sync(data)
    return unless @room.user == current_user

    RoomsChannel.broadcast_to(@room, data)
  end
end