class User < ApplicationRecord
  has_secure_password
  has_many :messages, foreign_key: [:sender_id, :receiver_id]
  has_many :chats, foreign_key: [:sender_id, :receiver_id]
  has_many :friends, foreign_key: [:sender_id, :receiver_id]

  def create_img(img)
    file_path = "storage/imgs/#{DateTime.now() + img["infos"]["name"]}"
    File.open(file_path, "w+") { |f| f.write(img["dataUrl"]) }
    
    file_path
  end

  private
  self.ignored_columns = [:password, :password_digest]

  scope :email, -> email { where(email: email) }
  scope :username, -> username { where(username: username) }
end
