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

    RoomMessage.create(data: data, from: current_user.id, to: @room.id)
  end

  private

  def appear
    data = notice('已加入！')
    RoomMessage.create(data: data, from: current_user.id, to: @room.id)
  end

  def disappear
    data = notice('已退出！')
    RoomMessage.create(data: data, from: current_user.id, to: @room.id)
  end

  def notice(content)
    { action: 'notice', msg: "#{current_user.email} #{content}" }
  end
end