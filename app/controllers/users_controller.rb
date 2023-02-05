class UsersController < ApplicationController
  before_action :require_login
  has_scope :email
  has_scope :username

  def index
    users = apply_scopes(User.all)
    render json: { users: users.to_json }
  end

  def show
    user = User.find(items_params[:id])
    render json: { user: user.to_json }
  end

  def create
    profile_image = nil

    if items_params[:profile_image].present?
      profile_image = User.create_img(items_params[:profile_image])
    end

    user = User.create(items_params, profile_image: profile_image)
    render json: { user: user.to_json }
  end

  def update
    user = User.find(items_params[:id])
    profile_image = nil

    if items_params[:profile_image].present?
      profile_image = User.create_img(items_params[:profile_image])
    end

    user.update(items_params)
  end

  private
  def items_params
    params.permit(:id, :email, :username, :password, :profile_image, :status)
  end
end
