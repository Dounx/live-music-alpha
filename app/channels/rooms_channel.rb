class RoomsChannel < ApplicationCable::Channel
  def subscribed
    @room = Room.find(params[:id])
    stream_for @room
    appear
  end

  def unsubscribed
    disappear
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

  private

  def appear
    RoomsChannel.broadcast_to(@room, { action: 'notice', msg:"#{current_user.email} 已加入！" })
  end

  def disappear
    RoomsChannel.broadcast_to(@room, { action: 'notice', msg:"#{current_user.email} 已退出！" })
  end
end