class Ticket < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates_associated :user

  validates :title, presence: true
  validates :text, presence: true
  validates :priority, presence: true

  before_validation :set_default_priority
  before_create :set_status

  enum priority: {
    low: 6,
    medium: 5,
    high: 4,
    urgent: 3,
    emergency: 2,
    critical: 1
  }

  enum status: {
    open: 1,
    awaiting_user_reply: 2,
    resolved: 3,
    closed: 4
  }

  private

  def set_default_priority
    self.priority = 6 if priority.blank?
  end

  def set_status
    self.status = 1
  end
end
