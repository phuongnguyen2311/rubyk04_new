# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 99.times do |n|
#   name = "Phuong Nguyen #{n}"
#   email = "example-#{n+1}@railstutorial.org"
#   password = "password"
#   begin
#     User.create!(name: name,
#     email: email,
#     password: password,
#     password_confirmation: password)
#   rescue => e
#     byebug
#   end
# end
users = User.all
user = User.find(227)
following = users[2..20]
followers = users[3..15]
following.each{|followed| user.follow(followed)}
followers.each{|follower| follower.follow(user)}