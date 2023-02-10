class ChatsController < ApplicationController
  before_action :require_login

  def index
    chats = Chat.all
      .where('chats.sender_id = ? OR chats.receiver_id = ?', @user.id, @user.id)
      .joins('INNER JOIN users ON users.id = chats.sender_id OR users.id = chats.receiver_id')
      .where('users.id != ?', @user.id)
      .select('users.id as user_id, users.username, users.profile_image, users.status, chats.id AS id, chats.last_message_id, chats.created_at')
      .order('chats.created_at DESC')

    chats = User.users_with_img(chats)
    render json: { chats: chats.as_json(:includes => [:message]) }
  end

  def create
    chat = Chat
      .where(sender_id: @user.id, receiver_id: params[:receiver_id])
      .or(Chat.where(sender_id: params[:receiver_id], receiver_id: @user.id))

    if chat.exists?
      return render json: show(chat.first.id)
    end

    chat = Chat.create(sender_id: @user.id, receiver_id: params[:receiver_id])
    render json: show(chat.id)
  end

  private
  def show(id) 
    chat = Chat
      .where(id: id)
      .joins('INNER JOIN users ON users.id = chats.sender_id OR users.id = chats.receiver_id')
      .where('users.id != ?', @user.id)
      .select('users.id as user_id, users.username, users.profile_image, users.status, chats.id AS id, chats.last_message_id, chats.created_at')

    chat = User.users_with_img(chat)
    return { chat: chat.first.as_json(:includes => [:message]) }
  end

  def chat_params
    params.permit(:sender_id, :receiver_id, :message)
  end
end
