class CommentsController < ApplicationController
  before_action :set_ticket, :can_comment, :closed_ticket, only: :create

  def create
    @comment = Comment.new(comment_params)

    if @comment.save

      close_ticket = params['commit']&.include?('close')
      @comment.ticket.update(status: :closed) if close_ticket # close ticket

      redirect_to @comment.ticket, notice: 'Comment was saved successfully'
    else

      @error_messages = @comment.errors.full_messages
      redirect_to @comment.ticket, notice: 'An unexpected error occured, please try again'
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find(comment_params[:ticket_id])
  end

  def comment_params
    params.require(:comment).permit(%i[ticket_id text]).merge(user: current_user)
  end

  def can_comment
    return if super_user? || @ticket.comments?

    flash[:error] = 'Only super users can comment on new tickets'
    redirect_to @ticket
  end

  def closed_ticket
    return unless @ticket.status == :closed

    flash[:error] = 'Comments cannot be added to a closed ticket'
    redirect_to @ticket
  end

  def owns_ticket?
    current_user == @ticket.user
  end
end
