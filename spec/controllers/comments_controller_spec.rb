require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:agent) { create(:user, :agent) }
  let(:admin) { create(:user, :admin) }

  let(:ticket) { create(:ticket, user: user) }

  describe '#create' do
    it 'A super user can comment on a ticket' do
      sign_in agent

      comment_details = { ticket_id: ticket.id, text: "A Super user comment" }
      post :create, params: { comment: comment_details }

      expect(flash[:notice]).to eq 'Comment was saved successfully'
      assert_redirected_to ticket_path(ticket)
    end

    context 'Customer' do
      it "can not comment when a super user hasn't responded to the ticket" do
        sign_in user

        comment_details = { ticket_id: ticket.id, text: "The system would reject this user's comment" }
        post :create, params: { comment: comment_details }

        expect(flash[:error]).to eq 'Only super users can comment on new tickets'
        assert_redirected_to ticket_path(ticket)
      end

      it 'can comment when a super user has placed a comment on the ticket' do
        sign_in user2

        ticket.comments.create(user: agent, text: "An Agent's comment")
        comment_details = { ticket_id: ticket.id, text: 'User comment is saved here' }

        post :create, params: { comment: comment_details }

        expect(flash[:notice]).to eq 'Comment was saved successfully'
        assert_redirected_to ticket_path(ticket)
      end
    end
  end
end
