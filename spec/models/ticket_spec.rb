require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe 'validations' do
    let(:user) { create(:user) }

    it 'is invalid without a title' do
      ticket = Ticket.new(user: user, text: 'The app is down')
      expect { ticket.save! }
        .to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Title can't be blank")
    end

    it 'is invalid without a text' do
      ticket = Ticket.new(user: user, title: 'unresponsive app')
      expect { ticket.save! }
        .to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Text can't be blank")
    end

    it 'set priority to low if none was provided' do
      ticket = create(:ticket, title: 'unresponsive app', text: 'The app is down')
      expect(ticket.priority).to eq "low"
    end
  end

  describe 'associations' do
    it 'should have a valid user' do
      ticket = Ticket.new(user_id: 2, title: 'unresponsive app', text: 'The app is down')
      expect { ticket.save! }
        .to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: User must exist')
    end
  end
end
