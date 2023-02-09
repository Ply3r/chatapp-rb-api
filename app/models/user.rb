class User < ApplicationRecord
  has_secure_password

  has_many :messages, foreign_key: :sender_id
  has_many :messages, foreign_key: :receiver_id

  has_many :chats, foreign_key: :sender_id
  has_many :chats, foreign_key: :receiver_id

  has_many :friends, foreign_key: :sender_id
  has_many :friends, foreign_key: :receiver_id

  def self.create_img(img)
    file_path = "storage/imgs/#{Time.now.to_i}#{img["info"]["name"].gsub(" ", "_")}"
    File.open(file_path, "w+") { |f| f.write(img["dataUrl"]) }
    
    file_path
  end

  def self.users_with_img(users)
    users.each do |user|
      if user[:profile_image].nil? 
        next
      end;
      
      file = File.open(user[:profile_image], "rb");
      user[:profile_image] = file.read
    end

    users
  end

  def self.user_with_img(user)
    if user[:profile_image].nil? 
      return user.as_json;
    end;
    
    file = File.open(user[:profile_image], "rb");
    users_with_img = user.as_json
    users_with_img[:profile_image] = file.read

    users_with_img
  end

  private
  scope :search, -> search { where('username LIKE ? OR email LIKE ?', "%#{search}%", "%#{search}%") }
end
