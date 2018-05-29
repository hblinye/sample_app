User.create!(name:  "Example_User",
             email: "example@railstutorial.org",
             account_name:          "foobar",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)
             
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  account_name = "example_#{n+1}"
  password = "password"
  User.create!(name:  name,
               account_name: account_name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

15.times do
  message = Faker::Lorem.sentence(5)
  users.each { |user| user.messages.create!(message: message, to_account_name: "example_#{rand(1..6)}") }
end

# リレーションシップ
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }