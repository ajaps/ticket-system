class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :ticket

  validates_associated :user
  validates_associated :ticket

  validates :text, presence: true
end
