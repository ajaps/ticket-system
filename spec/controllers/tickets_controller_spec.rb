require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  let(:user) { create(:user) }
  let(:agent) { create(:user, :agent) }
  let(:admin) { create(:user, :admin) }

  let(:ticket) { create(:ticket, user: user, priority: :high) }

  describe '#index' do
    it 'should get index' do
      sign_in user
      get :index

      assert_response :success
    end
  end

  describe '#new' do
    it 'should get new' do
      sign_in user
      get :new

      assert_response :success
    end
  end

  describe '#create' do
    context 'when the right parameters are provides' do
      it 'should create ticket' do
        sign_in user

        ticket_params = { title: 'New Ticket', text: 'Server is down' }
        post :create, params: ticket_params

        expect(Ticket.last.text).to eq ticket_params[:text]

        assert_redirected_to ticket_path(Ticket.last.id)
      end
    end

    context 'when parameters are missing' do
      it 'should not create ticket' do
        sign_in user

        ticket_params = { title: 'New Ticket' }
        post :create, params: ticket_params

        expect(response).to render_template(:new)
      end
    end
  end

  describe '#update' do
    context 'Only the assignee_id attributes is updateable by an Agent' do
      it 'should update ticket' do
        sign_in agent

        unchanged_priority = ticket.priority

        put :update, params: { id: ticket.id, assignee_id: agent.id, priority: :low }

        expect(flash[:notice]).to eq "Ticket was successfully updated"
        expect(ticket.priority).to eq unchanged_priority
        assert_redirected_to ticket_path(ticket.id)
      end
    end

    context "Only an Admin can change a ticket's priority" do
      it 'should update ticket' do
        sign_in admin

        priority_will_change = ticket.priority

        put :update, params: { id: ticket.id, assignee_id: agent.id, priority: :low }

        expect(flash[:notice]).to eq "Ticket was successfully updated"
        expect(ticket.reload.priority).to_not eq priority_will_change
        assert_redirected_to ticket_path(ticket.id)
      end
    end
  end

  describe '#destroy' do
    let(:new_ticket) { create(:ticket) }

    context 'Users or Agents cannot delete tickets' do
      it 'should not delete ticket' do
        sign_in agent

        delete :destroy, params: { id: new_ticket.id }

        expect(flash[:error]).to eq 'You must be an Admin to perform this operation'
        assert_redirected_to root_path
      end
    end

    context 'Admin can delete tickets' do
      it 'should delete ticket' do
        sign_in admin

        delete :destroy, params: { id: new_ticket.id }

        expect(flash[:notice]).to eq 'Ticket was deleted successfully'
        assert_redirected_to root_path
      end
    end
  end
end
