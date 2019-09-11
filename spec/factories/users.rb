FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { 'user@user.com' }
    password_digest { 'correct' }
  end
end