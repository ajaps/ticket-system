FactoryBot.define do
  factory :comment do
    sequence(:title, 10) { |r| "My comment ##{ r }" }
    ticket
    user
  end
end
