class RoomsChannel < ApplicationCable::Channel
  def subscribed
    @room = Room.find(params[:id])
    stream_for @room
  end

  def unsubscribed; end

  def join
    RoomsChannel.broadcast_to(@room, { action: 'notice', msg:"#{current_user.email} 已加入！" })
  end

  def exit
    RoomsChannel.broadcast_to(@room, { action: 'notice', msg:"#{current_user.email} 已退出！" })
    @room.destroy if @room.user == current_user
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