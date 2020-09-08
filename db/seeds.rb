# Examples:
# movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# Character.create(name: 'Luke', movie: movies.first)
User.create(
  name: "Phan Trong Thuc",
  email: "ptthuc77@gmail.com",
  password: "202201",
  password_confirmation: "202201",
  admin: true,
  activated: true,
  activated_at: Time.zone.now
)

30.times do |n|
  User.create(
    name: Faker::Name.name,
    email: "test#{n}@gmail.com",
    password: "123456",
    activated: true,
    activated_at: Time.zone.now
  )
end

users = User.where "id < 10"
5.times do
  users.each{|user| user.microposts.create content: Faker::Lorem.sentence}
end

users = User.all
user = User.first
following = users[2..20]
followers = users[5..30]
following.each{|followed| user.follow followed}
followers.each{|follower| follower.follow user}
