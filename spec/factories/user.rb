FactoryBot.define do
  factory :user do
    sequence(:name){|n| n }
    sequence(:email){|n| "user#{n}@factory.com" }
    password { 'qwerty' }
  end

  trait :admin do
    admin { true }
  end

  trait :agent do
    agent { true }
  end
end
