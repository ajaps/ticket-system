class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_super_user!, only: :update
  before_action :require_admin!, only: :destroy
  before_action :set_ticket, only: %i[show update destroy]
  before_action :form_data, only: %i[new edit create show]
  before_action :comment, only: :show
  before_action :available_status, only: :show
  before_action :available_support_team, if: -> { admin? }
  before_action :require_access!, only: :show

  def index
    @tickets = Ticket.order(:created_at) if super_user?

    @tickets ||= current_user.tickets
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(create_ticket_params.merge(user: current_user))
    if @ticket.save
      redirect_to @ticket
    else
      @error_messages = @ticket.errors.full_messages
      render :new
    end
  end

  def update
    ticket = @ticket.update(update_ticket_params)

    if ticket
      redirect_to @ticket, notice: 'Ticket was successfully updated'
    else
      @error_messages = @ticket.errors.full_messages
      redirect_to @ticket, notice: 'An error occured while updating the ticket'
    end
  end

  def destroy
    @ticket.destroy

    redirect_to root_path, notice: 'Ticket was deleted successfully'
  end

  private

  def priority
    @priority = Ticket.priorities.map { |p| [p.first, p.first] }
  end

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def available_support_team
    @team = User.team.pluck(:name, :id)
  end

  def comment
    @comment = Comment.new(ticket: @ticket, user: current_user)
  end

  def create_ticket_params
    params.permit(%i[text title user_id priority])
  end

  def update_ticket_params
    return params.permit(%i[priority status assignee_id]) if admin?

    { assignee: current_user }
  end

  def available_status
    @available_status = Ticket.statuses.map { |p| [p.first.capitalize, p.first] } if admin?
    @available_status ||= %w[closed closed] if agent?
  end

  def form_data
    @priority = Ticket.priorities.map { |p| [p.first.capitalize, p.first] }
  end

  def require_access!
    return if super_user?
    return if @ticket.user == current_user

    redirect_to root_path, notice: 'You do not have access to view this ticket'
  end
end
