namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
    make_reply_microposts
    make_conversations
    make_message
  end
end

def make_users
  admin = User.create!(name: "Example User",
               email: "example@railstutorial.jp",
               nickname: "ExUser",
               password: "foobar",
               password_confirmation: "foobar",
               admin: true )
  k_n = User.create!(name: "kosei nishi",
               email: "kosei.nishi@litalico.co.jp",
               nickname: "k_n",
               password: "foobar",
               password_confirmation: "foobar",
               admin: true )
  80.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.jp"
    nickname = "Ex#{n+1}"
    password  = "password"
    User.create!(name: name,
                 email: email,
                 nickname: nickname,
                 password: password,
                 password_confirmation: password,
                 admin: false)
  end
end

def make_microposts
  users = User.all.limit(6)
  20.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_reply_microposts
  users = User.all.limit(6)
  reply_users = User.all.limit(6)
  users.each do |user|
    reply_users.each do |reply_user|
      content = "@#{reply_user.nickname} from #{user.name}"
      user.microposts.create!(content: content, in_reply_to: reply_user)
    end
  end
end

def make_conversations
  send_message_user = User.find(1)
  users = User.all.limit(6).offset(1)
  users.each do |users|
    Conversation.create!(low_user_id:send_message_user.id, high_user_id:users.id)
  end
end

def make_message
  conversations = Conversation.all
  users = User.all.limit(6).offset(1)
  send_message_user = User.find(1)
  t = 0
  conversations.each do |conversation|
    users.each do |user|
      t = t + 1;
      content = "d @#{send_message_user.nickname} from #{user.name} DM#{t+1}"
      conversation.message.create!(content: content, sender_id: user.id, reciptient_id: "#{send_message_user.id}",read: "f")
      content1 = "d @#{user.nickname} from #{send_message_user.name} DM#{t+1}"
      conversation.message.create!(content: content1, sender_id: "#{send_message_user.id}", reciptient_id: user.id,read: "f")
    end
  end
end


def make_relationships
  users = User.all
  user  = users.first
  #ユーザ3から51までフォローし、4から41まで最初のユーザをフォローさせる
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end
