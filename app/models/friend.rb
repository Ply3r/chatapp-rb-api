class Friend < ApplicationRecord
  belongs_to :user, foreign_key: :sender_id, :class_name => 'User'
  belongs_to :user, foreign_key: :receiver_id, :class_name => 'User'

  private
  scope :sender_id, -> sender_id { where(sender_id: sender_id) }
  scope :receiver_id, -> receiver_id { where(receiver_id: receiver_id) }
  scope :status, -> status { where(status: status) }
end
