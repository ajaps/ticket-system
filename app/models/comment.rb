class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :ticket

  validates_associated :user
  validates_associated :ticket

  validates :text, presence: true

  after_save :set_activity_time_on_ticket

  attr_reader :status

  private

  def set_activity_time_on_ticket
    ticket.touch(:updated_at)
  end
end
