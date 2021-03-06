class ChatsController < ApplicationController
  def show
    @user = User.find(params[:id])   # 誰とDMするのか
    rooms = current_user.user_rooms.pluck(:room_id)
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    unless user_rooms.nil?  # もしChatroomが在れば、＠roomにuser_roomのroomを代入
      @room = user_rooms.room
    else  # 無ければ新しくroomを作る
      @room = Room.new
      @room.save
      UserRoom.create(user_id: current_user.id, room_id: @room.id)  # user_roomをカレントユーザー分とチャット相手分を作る
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end
    @chats = @room.chats.reverse
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    @chat = current_user.chats.new(chat_params)
    # if @chat.save
    #   redirect_to request.referer
    # else
    #   flash.now[:alert] = 'メッセージを入力してください。'
    #   render "create"
    # end
    @chat.save


  end

  private
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end
end
