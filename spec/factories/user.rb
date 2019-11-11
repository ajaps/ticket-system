FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'qwerty' }
  end

  trait :admin do
    admin { true }
  end

  trait :agent do
    agent { true }
  end
end
