# Users
user1 = User.create(
  username: 'leandrex', 
  email: 'leandrex@admin.com', 
  password_digest: 'admin',
  status: false,
)

user2 = User.create(
  username: 'admin', 
  email: 'admin@admin.com', 
  password_digest: 'admin',
  status: false,
)
