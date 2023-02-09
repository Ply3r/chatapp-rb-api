require "#{Rails.root}/lib/token"

class ApplicationController < ActionController::API
  around_action :switch_locale

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def require_login
    token = request.headers['Authorization']

    unless token.present?
      return render json: { message:  I18n.t(:not_authorized) }, status: 401
    end

    user_data = Token.decode(token)
    user = User.find_by(email: user_data[0]["email"], password_digest: user_data[0]["password_digest"])

    unless user.present?
      return render json: { message:  I18n.t(:not_authorized) }, status: 401
    end

    @user = user
  end
end
