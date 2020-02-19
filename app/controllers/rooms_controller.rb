class RoomsController < ApplicationController
  after_action :cors_set_access_control_headers

  def index; end

  def show
    id = params[:id]
    @room ||= Room.find_by_id(id)
  end

  def new
    @room = Room.new
  end

  def create
    @room = current_user.rooms.build(room_params)

    if @room.save
      flash[:notice] = 'Room added!'
      redirect_to room_path(@room)
    else
      render 'new'
    end
  end

  def join
    token = params[:token]
    @room = Room.find_by_token(token)

    if @room
      flash[:notice] = 'Join room!'
      render 'show'
    else
      flash[:alert] = 'Invalid token'
      render 'rooms/index'
    end
  end

  private

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = 'music.163.com'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, PATCH, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  def room_params
    params.require(:room).permit(:url)
  end
end
