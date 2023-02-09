class UsersController < ApplicationController
  before_action :require_login, except: [:create]
  has_scope :email
  has_scope :username
  has_scope :search

  def index
    users = apply_scopes(User.all)
      .joins('LEFT JOIN friends ON friends.receiver_id = users.id')
      .where('friends.sender_id != ? OR friends.sender_id IS NULL', @user.id)
      .where('users.id != ?', @user.id)
      .page(params[:page] || 1)
      .per(params[:per_page] || 10)
      .order(params[:order_by] || :created_at)

    users = User.users_with_img(users)
    render json: { users: users.as_json(except: :password_digest) }
  end

  def show
    user = User.user_with_img(User.find(params[:id]))
    render json: { user: user.as_json(except: :password_digest) }
  end

  def self
    user = User.user_with_img(@user)
    render json: { user: user.as_json(except: :password_digest) }
  end

  def create
    profile_image = nil

    if params[:profile_image].present?
      profile_image_url = User.create_img(params[:profile_image])
    end

    user = User.create!(
      username: params[:username], 
      email: params[:email], 
      password: params[:password], 
      profile_image: profile_image_url
    )

    render json: { user: user.as_json(except: :password_digest) }
  end

  def update
    user = User.find(user_params[:id])
    profile_image = nil

    if params[:profile_image].present?
      profile_image = User.create_img(user_params[:profile_image])
    end

    user.update(user_params)
  end

  def connected
    user.update(status: true)
  end

  def disconnected
    user.update(status: false)
  end

  private
  def user_params
    params.permit(:id, :email, :username, :password, :profile_image, :user, :status)
  end
end
