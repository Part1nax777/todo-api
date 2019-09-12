FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { 'user@user.com' }
    password { 'correct' }
    password_digest { 'correct' }
  end
end