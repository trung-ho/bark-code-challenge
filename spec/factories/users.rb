FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end
  factory :user do
    name { "John" }
    email
    password { 'password' }
  end
end
