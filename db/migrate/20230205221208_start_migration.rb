class StartMigration < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.boolean :status, :default => false
      t.string :profile_image
      t.timestamps
    end

    create_table :friends, id: :uuid do |t|
      t.uuid :sender_id
      t.uuid :receiver_id
      t.boolean :status, :default => false
      t.timestamps
    end

    create_table :messages, id: :uuid do |t|
      t.uuid :sender_id
      t.uuid :receiver_id
      t.string :content
      t.boolean :received, :default => false
      t.boolean :readed, :default => false
      t.timestamps
    end

    create_table :chats, id: :uuid do |t|
      t.uuid :sender_id
      t.uuid :receiver_id
      t.uuid :last_message_id
      t.timestamps
    end

    add_index :users, :username
    add_index :users, :email

    add_index :friends, :sender_id
    add_index :friends, :receiver_id

    add_index :chats, :sender_id
    add_index :chats, :receiver_id
    add_index :chats, :last_message_id

    add_index :messages, :sender_id
    add_index :messages, :receiver_id
  end
end
