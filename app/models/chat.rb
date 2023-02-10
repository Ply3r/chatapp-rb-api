class Chat < ApplicationRecord
  belongs_to :user, foreign_key: :sender_id, :class_name => 'User'
  belongs_to :user, foreign_key: :receiver_id, :class_name => 'User'
  belongs_to :message, foreign_key: :last_message_id, :class_name => 'Message', optional: true
end
