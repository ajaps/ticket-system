FactoryBot.define do
  factory :ticket do
    sequence(:title, 10) { |r| "Ticket title ##{ r }" }
    text { Faker::Lorem.sentences(number: 6).join(' ') }
    user
  end
end
