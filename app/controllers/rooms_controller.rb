class RoomsController < ApplicationController
  def index
    @rooms = current_user.rooms
  end

  def show
    @room = current_user.rooms.find(params[:id])
  end

  def new
    @room = Room.new
  end

  def create
    @room = current_user.rooms.build(room_params)

    if @room.save
      flash[:notice] = '房间已创建！'
      redirect_to join_rooms_path(token: @room.token)
    else
      render 'new'
    end
  end

  def join
    token = params[:token]
    return unless token.present?

    @room = Room.find_by_token(token)
    if @room
      flash[:notice] = '已加入房间！'
      # No need to refresh id
      # @room.refresh
      render 'show'
    else
      flash[:error] = '错误令牌！'
    end
  end

  def lrc
    song_id = params[:song_id]
    prefix = 'http://127.0.0.1:4000/lyric?id='
    api = URI.parse(prefix + song_id)
    res = Net::HTTP.get(api)
    data = JSON.parse(res)['lrc']&.fetch('lyric')
    render json: data&.squish
  end

  private

  def room_params
    params.require(:room).permit(:url)
  end
end
