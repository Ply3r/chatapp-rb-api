class ApplicationController < ActionController::API
  def require_login
    true
  end
end
