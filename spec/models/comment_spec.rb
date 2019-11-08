require 'rails_helper'

RSpec.describe Comment, type: :model do
  let!(:user) { create(:user) }
  let(:ticket) { create(:ticket, user: user) }

  describe 'validations' do
    it 'is invalid without a text' do
      comment = Comment.new(user: user, ticket: ticket)
      expect { comment.save! }
        .to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Text can't be blank")
    end
  end

  describe 'associations' do
    it 'should have a valid user' do
      NON_EXISTENT_USER = '20p'.freeze
      comment = Comment.new(user_id: NON_EXISTENT_USER, ticket: ticket, text: 'this issue has been resolved')
      expect { comment.save! }
        .to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: User must exist')
    end

    it 'should have a valid ticket' do
      comment = Comment.new(user: user, ticket_id: 4, text: 'this issue has been resolved')
      expect { comment.save! }
        .to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Ticket must exist')
    end
  end
end
