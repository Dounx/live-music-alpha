class RoomsController < ApplicationController
  include RoomsHelper

  def index; end

  def show
    room = current_user.rooms.find(params[:id])
    redirect_to share_url(room)
  end

  def new
    @room = Room.new
  end

  def create
    room = current_user.rooms.build(room_params)

    if room.save
      flash[:notice] = '房间已创建！'
      redirect_to join_rooms_path(token: room.token)
    else
      render 'new'
    end
  end

  def join
    token = params[:token]
    return unless token.present?

    @room = Room.find_by_token(token)
    if @room
      render 'show'
    else
      flash[:error] = '错误令牌！'
    end
  end

  def lrc
    render json: Api.lrc(params[:song_id])
  end

  private

  def room_params
    params.require(:room).permit(:url)
  end
end
