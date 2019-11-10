FactoryBot.define do
  factory :comment do
    sequence(:text, 10) { |r| "My comment ##{ r }" }
    ticket
    user
  end
end
