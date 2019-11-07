class CommentsController < ApplicationController
  before_action :ticket, only: :create
  before_action :can_comment, only: :create

  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save

        format.html { redirect_to @ticket, notice: "Comment was saved successfully" }
        format.json { render json: @comment, status: :ok }
      else
        @error_messages = @comment.errors.full_messages

        format.html { redirect_to @ticket, notice: "An error occured while saving comment, please try again" }
        format.json { render json: @error_messages, status: :unprocessable_entity }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(%i[user_id ticket_id text])
  end

  def can_comment
    return if admin? || agent?
    return if current_user.id.to_s == comment_params['user_id'] && owns_ticket?

    flash[:error] = 'You do not the required access to this account'
    redirect_to root_path
  end

  def ticket
    @ticket = Ticket.find(comment_params['ticket_id'])
  end

  def owns_ticket?
    current_user == @ticket.user
  end
end
