class FriendsController < ApplicationController
  before_action :require_login

  def index
    if params[:search].present?
      friends = apply_scopes(Friend.all)
        .joins('INNER JOIN users ON users.id = friends.sender_id OR users.id = friends.receiver_id')
        .where('(friends.sender_id = ? OR friends.receiver_id = ?) AND friends.status = true', @user.id, @user.id)
        .where('users.username LIKE ? OR users.email LIKE ?', "%#{friend_params[:search]}%", "%#{friend_params[:search]}%")
        .where('users.id != ?', @user.id)
        .select('users.id, users.username, users.profile_image, friends.id AS friend_id, friends.status')

      friends = User.users_with_img(friends)
      return render json: { friends: friends.as_json }
    end

    friends = Friend.all
      .joins('INNER JOIN users ON users.id = friends.sender_id OR users.id = friends.receiver_id')
      .where('(friends.sender_id = ? OR friends.receiver_id = ?) AND friends.status = true', @user.id, @user.id)
      .where('users.id != ?', @user.id)
      .select('users.id, users.username, users.profile_image, friends.id AS friend_id, friends.status')

    friends = User.users_with_img(friends)
    render json: { friends: friends.as_json }
  end

  def sent
    friends = User
      .joins('INNER JOIN friends ON friends.receiver_id = users.id')
      .where('friends.sender_id = ? AND friends.status = false', @user.id)
      .select('users.id, users.username, users.profile_image, friends.id AS friend_id')

    friends = User.users_with_img(friends)
    render json: { friends: friends.as_json }
  end

  def received
    friends = User
      .joins('INNER JOIN friends ON friends.sender_id = users.id')
      .where('friends.receiver_id = ? AND friends.status = false', @user.id)
      .select('users.id, users.username, users.profile_image, friends.id AS request_id, friends.status')

    friends = User.users_with_img(friends)
    render json: { friends: friends.as_json }
  end

  def create
    params = { sender_id: @user.id, receiver_id: friend_params[:receiver_id] }

    request_exists = Friend.where('(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)', @user.id, friend_params[:receiver_id], friend_params[:receiver_id], @user.id).exists?
    if request_exists
      return render json: { message: 'Request already exists' }, status: 400
    end

    friend = Friend.create(params)
    render json: { friend: friend.as_json }
  end

  def accept
    friend = Friend.find(friend_params[:id])
    friend.update(status: true)
  end

  def destroy
    friend = Friend.find(friend_params[:id])
    friend.destroy
  end

  private
  def friend_params
    params.permit(:id, :search, :sender_id, :receiver_id, :status)
  end
end
