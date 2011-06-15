Factory.define(:user) do |f|
  f.email { Faker::Internet.email }
  f.first_name { Faker::Name.first_name }
  f.last_name { Faker::Name.last_name }
  f.privacy_allow_messages true
end

Factory.define(:message) do |f|
  f.association(:user)
  f.association(:receiver, :factory => :user)
  f.message { Faker::Lorem.paragraph }
  f.unread_receiver false
  f.deleted_receiver false
  f.warned false
end

Factory.define(:unread_message, :parent => :message) do |f|
  f.unread_receiver true
  f.deleted_receiver false
end

Factory.define(:challenge) do |f|
  f.association(:user, :factory => :user)
  f.association(:achievement)
  f.title { Faker::Lorem.sentence }
  f.details { Faker::Lorem.paragraph }
  f.editor_pick false
  f.location 'Harvard University'
  f.lat 42.3647
  f.lng 71.0774
  f.points 2
  f.budget 0
  f.city 'Cambridge'
  f.sum_completed 0
  f.sum_todo_list 0
  f.proof 'Take a picture of yourself doing something stupid.'
  f.published true
end

Factory.define(:subscribed_challenge) do |f|
  f.association(:user)
  f.association(:challenge)
  f.note { Faker::Lorem.sentence }
  f.goal_date Time.now + 7.days
end

Factory.define(:achievement) do |f|
  f.sequence(:name) { |n| "Achievement-#{n}" }
end

Factory.define(:block) do |f|
  f.association(:user)
  f.association(:receiver, :factory => :user)
  f.flag false
end

Factory.define(:block_with_flag, :parent => :block) do |f|
  f.flag true
  f.flag_reason 'is jerks'
end
