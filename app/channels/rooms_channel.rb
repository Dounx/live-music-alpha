class RoomsChannel < ApplicationCable::Channel
  def subscribed
    @room = Room.find(params[:id])
    stream_for @room
    join
  end

  def unsubscribed
    exit
  end

  def sync(data)
    return unless @room.user == current_user

    RoomMessage.create(data: data, from: current_user.id, to: @room.id)
  end

  private

  def join
    @room.increment!(:user_counter)
    data = notice('已加入！')
    RoomMessage.create(data: data, from: current_user.id, to: @room.id)
  end

  def exit
    @room.decrement!(:user_counter)
    data = notice('已退出！')
    RoomMessage.create(data: data, from: current_user.id, to: @room.id)
  end

  def notice(content)
    {
      action: 'notice',
      msg: "#{current_user.email} #{content}",
      user_counter: @room.user_counter
    }
  end
end