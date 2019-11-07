class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_super_user!, only: :update
  before_action :set_ticket, only: %i[show update]
  before_action :form_data, only: %i[new edit create]
  before_action :comment, only: :show
  before_action :available_status, only: :show

  def index
    @tickets = Ticket.order(:created_at) if super_user?

    @tickets ||= current_user.tickets
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(ticket_params.merge(user: current_user))
    if @ticket.save
      redirect_to @ticket
    else
      @error_messages = @ticket.errors.full_messages
      render :new
    end
  end

  def update
    ticket = @ticket.update_attributes(assignee: current_user) if agent?
    ticket =@ticket.update_attributes(update_ticket_params) if admin?

    if ticket
      redirect_to @ticket, notice: "Ticket was successfully updated"
    else
      @error_messages = @ticket.errors.full_messages
      redirect_to @ticket, notice: "An error occured while updating the ticket"
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def comment
    @comment = Comment.new(ticket: @ticket, user: current_user)
  end

  def ticket_params
    params.require(:ticket).permit(%i[text title user_id priority])
  end

  def update_ticket_params
    params.require(:ticket).permit(%i[priority status assignee])
  end

  def available_status
    @available_status = Ticket.statuses.map { |p| [p.first, p.first] } if admin?
    @available_status ||= ['closed', 'closed'] if agent?
  end

  def form_data
    @priority = Ticket.priorities.map { |p| [p.first, p.first] }
  end
end
