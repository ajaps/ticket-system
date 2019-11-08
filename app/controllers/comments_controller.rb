class CommentsController < ApplicationController
  before_action :ticket, :can_comment, :ticket_priviledges, only: :create

  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      close_ticket = params['commit'].include?('close')
      @comment.ticket.update(status: :closed) if super_user? && close_ticket # close ticket

      redirect_to @ticket, notice: 'Comment was saved successfully'
    else

      @error_messages = @comment.errors.full_messages
      redirect_to @ticket, notice: 'An error occured while saving comment, please try again'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(%i[user_id ticket_id text])
  end

  def ticket_priviledges
    return @status = { status: :awaiting_user_reply } if super_user?
    return @status = { status: :open } if current_user.id.to_s == comment_params['user_id'] && owns_ticket?

    flash[:error] = 'You do not have the required access to this account'
    redirect_to root_path
  end

  def can_comment
    return unless @ticket.status == 'closed'

    flash[:error] = 'Comments cannot be added to a closed ticket'
    redirect_to @ticket
  end

  def ticket
    @ticket = Ticket.find(comment_params['ticket_id'])
  end

  def owns_ticket?
    current_user == @ticket.user
  end
end
