class LoginController < ApplicationController
  def login
    user = User.find_by(email: user_params[:email])

    unless user
      return render json: { message:  I18n.t(:not_authorized) }, status: 401
    end

    user = user.authenticate(user_params[:password])

    unless user
      return render json: { message:  I18n.t(:not_authorized) }, status: 401
    end

    user = User.user_with_img(user)
    render json: { user: user.except(:password_digest), token: Token.encode(user) }
  end

  private
  def user_params
    params.permit(:email, :password)
  end
end
