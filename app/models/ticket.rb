class Ticket < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates_associated :user

  validates :title, presence: true
  validates :text, presence: true
  validates :priority, presence: true

  before_validation :set_default_priority

  enum priority: {
    low: 6,
    medium: 5,
    high: 4,
    urgent: 3,
    emergency: 2,
    critical: 1
  }

  private

  def set_default_priority
    self.priority = 6 if priority.blank?
  end
end
