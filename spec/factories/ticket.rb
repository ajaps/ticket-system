FactoryBot.define do
  factory :ticket do
    sequence(:title, 10) { |r| "Ticket title ##{ r }" }
    text { Faker::Lorem.sentences(2..4).join(' ') }
    user
  end
end
