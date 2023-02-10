class MessagesController < ApplicationController
  before_action :require_login

  def index
    messages = User.find(@user.id)
      .joins('INNER JOIN messages ON messages.sender_id = users.id OR messages.receiver_id = users.id')
  end
end
