class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :assignee, class_name: 'User', optional: true
  has_many :comments, dependent: :destroy

  validates_associated :user

  validates :title, presence: true
  validates :text, presence: true
  validates :priority, presence: true

  before_validation :set_default_priority
  before_create :set_status

  enum priority: {
    critical: 1,
    emergency: 2,
    urgent: 3,
    high: 4,
    medium: 5,
    low: 6
  }

  enum status: {
    open: 1,
    awaiting_user_reply: 2,
    closed: 4
  }

  default_scope { order(:status, :priority, :created_at) }
  scope :visible, ->(user_id) { where('user_id = ? OR assignee_id = ?', user_id, user_id).order(:created_at) }
  scope :open, -> { where(status: :open).or(where(status: :awaiting_user_reply)) }
  scope :closed, -> { where(status: :closed) }

  def self.assigned_open_tickets(user_id)
    where(assignee_id: user_id, status: :open).or(where(status: :awaiting_user_reply))
  end

  def self.assigned_closed_tickets(user_id)
    where(assignee_id: user_id, status: :closed)
  end

  def self.assigned_tickets(user_id)
    where(assignee_id: user_id)
  end

  def comments?
    comments.present?
  end

  private

  def set_default_priority
    self.priority = 6 if priority.blank?
  end

  def set_status
    self.status = 1
  end
end
