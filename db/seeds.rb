# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
users = []
10.times do |n|
  name = Faker::Name.name # ランダムな名前を生成
  email = Faker::Internet.email # ランダムなメールアドレスを生成
  password = Faker::Internet.password(min_length: 8) # ランダムなパスワードを生成
  user = User.create(name: name, email: email, password: password) # ユーザーを作成
  users << user
  puts "#{n} create done"
end

microposts = []
users.each do |user|
  10.times do
    title = Faker::Lorem.sentence(word_count: 5) # ランダムな5単語で構成されるタイトルを生成
    body = Faker::Lorem.sentence(word_count: 100) # ランダムな100単語で構成される本文を生成
    micropost = Micropost.new(title: title, body: body)
    micropost.user = user # micropostのuserにuserを設定
    microposts << micropost
  end
end

Micropost.import microposts