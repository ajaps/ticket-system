class User < ApplicationRecord
  has_many :tickets, dependent: :destroy
  has_many :comments

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validate :cannot_be_an_admin_and_agent

  scope :team, -> { where('agent = ? OR admin = ?', true, true).order(:admin) }

  private

  def cannot_be_an_admin_and_agent
    return unless admin && agent

    errors.add(:user, 'cannot be set as an admin and also an agent')
  end
end
