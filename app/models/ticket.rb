class Ticket < ApplicationRecord
  belongs_to :user
  has_many :comments

  enum priority: {
    low: 6,
    medium: 5,
    high: 4,
    urgent: 3,
    emergency: 2,
    critical: 1
  }
end
