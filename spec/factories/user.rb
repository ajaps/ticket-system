FactoryBot.define do
  factory :user do
    name { 'John Doe' }
    email { 'test@user.com' }
    password { 'qwerty' }
    admin { false }
    agent { false }
  end
end
