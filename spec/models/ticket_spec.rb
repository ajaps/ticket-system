require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:user) { create(:user) }

  describe 'validations' do

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

  describe 'default scope' do
    it 'should order tickets by status, priority then created_at' do
      ticket = create(:ticket, user: user, status: :open, priority: :critical)
      ticket2 = create(:ticket, user: user, status: :open, priority: :low)
      ticket3 = create(:ticket, user: user, status: :open, priority: :high)
      ticket4 = create(:ticket, user: user, status: :open, priority: :critical)
      ticket5 = create(:ticket, user: user, status: :open, priority: :low)

      ticket.update(status: :closed) # Close ticket

      expect(user.tickets.pluck(:id)).to eq [ticket4.id, ticket3.id, ticket2.id, ticket5.id, ticket.id]
    end
  end

  describe 'visible' do
    it 'should return ONLY tickets created or assigned to a user' do
      user2 = create(:user)
      ticket = create(:ticket, user: user2)
      ticket2 = create(:ticket, user: user)
      ticket3 = create(:ticket, user: user2)
      ticket4 = create(:ticket, user: user)
      ticket5 = create(:ticket, user: user, assignee: user2)

      expect(Ticket.visible(user2.id).pluck(:id)).to eq [ticket.id, ticket3.id, ticket5.id]
    end
  end

  describe 'open' do
    it 'should return Open tickets belonging to a user' do
      ticket = create(:ticket, user: user)
      ticket2 = create(:ticket, user: user)
      ticket3 = create(:ticket, user: user)

      ticket.update(status: :closed)
      ticket3.update(status: :awaiting_user_reply)

      expect(user.reload.tickets.open.pluck(:id)).to eq [ticket2.id, ticket3.id]
    end
  end

  describe 'closed' do
    it 'should return Closed tickets belonging to a user' do
      ticket = create(:ticket, user: user)
      ticket2 = create(:ticket, user: user)
      ticket3 = create(:ticket, user: user)

      ticket.update(status: :closed)
      ticket3.update(status: :closed)

      expect(user.reload.tickets.closed.pluck(:id)).to eq [ticket.id, ticket3.id]
    end
  end

  describe 'assigned_open_tickets' do
    it 'should return ALL Open tickets assigned to a user' do
      user2 = create(:user)

      ticket = create(:ticket, user: user, assignee: user2)
      ticket2 = create(:ticket, user: user2, assignee: user)
      ticket3 = create(:ticket, assignee: user2)
      ticket4 = create(:ticket, assignee: user)

      ticket4.update(status: :closed)

      expect(Ticket.assigned_open_tickets(user2.id).pluck(:id)).to eq [ticket.id, ticket3.id]
    end
  end

  describe 'assigned_closed_tickets' do
    it 'should return ALL Closed tickets assigned to a user' do
      user2 = create(:user)

      ticket = create(:ticket, user: user, assignee: user2)
      ticket2 = create(:ticket, user: user2, assignee: user)
      ticket3 = create(:ticket, assignee: user2)
      ticket4 = create(:ticket, assignee: user)

      ticket2.update(status: :closed)
      ticket3.update(status: :closed)

      expect(Ticket.assigned_closed_tickets(user2.id).pluck(:id)).to eq [ticket3.id]
    end
  end

  describe 'assigned_tickets' do
    it 'should return ALL tickets assigned to a user' do
      user2 = create(:user)

      ticket = create(:ticket, user: user, assignee: user2)
      ticket2 = create(:ticket, user: user2, assignee: user)
      ticket3 = create(:ticket, assignee: user2)
      ticket4 = create(:ticket, assignee: user)

      ticket2.update(status: :closed)
      ticket3.update(status: :closed)

      expect(Ticket.assigned_tickets(user2.id).pluck(:id)).to eq [ticket.id, ticket3.id]
    end
  end
end
