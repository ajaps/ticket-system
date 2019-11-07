class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ticket, only: :show
  before_action :form_data, only: %i[ new edit create ]
  before_action :comment, only: :show

  def index
    @tickets = Ticket.order(:created_at) if admin?

    @tickets ||= Ticket.visible(current_user.id) if agent?

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

  def form_data
    @priority = Ticket.priorities.map { |p| [p.first, p.first] }
  end
end
