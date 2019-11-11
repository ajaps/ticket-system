class TicketsController < ApplicationController
  require 'csv'

  before_action :authenticate_user!
  before_action :require_super_user!, only: :update
  before_action :require_admin!, only: %i[destroy download_report]
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
    @ticket = Ticket.new(user: current_user)
  end

  def create
    @ticket = Ticket.new(create_ticket_params)
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

  def export_to_csv
    status = params[:status].presence
    assignee_id = params[:assignee].presence

    tickets = Ticket.search(status, assignee_id, params[:from], params[:to])

    header = ['ID', 'Title', 'Created', 'Last Activity', 'Comments', 'Priority', 'Status']
    attributes = %w{id title created_at updated_at number_of_comments priority status}

    data = CSV.generate(headers: true) do |csv|
      csv << header

      tickets.each do |record|
        csv << attributes.map { |attr| record.send(attr) }
      end
    end

    send_data data, filename: "Ticket Report-#{Date.today}.csv"
  end

  def search
    status = params[:status].presence
    assignee_id = params[:assignee].presence

    @tickets = Ticket.search(status, assignee_id, params[:from], params[:to])
    render :index
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
    params.require(:ticket)
          .permit(%i[text title user_id priority])
          .merge(user_id: current_user.id)
  end

  def update_ticket_params
    return params.require(:ticket).permit(%i[priority status assignee_id]) if admin?

    { assignee: current_user }
  end

  def available_status
    @available_status = Ticket.statuses.map { |p| [p.first.capitalize, p.first] } if admin?
    @available_status ||= %w[closed closed] if agent?
  end

  def search_params
    {
      status: params[:status].presence,
      assignee_id: params[:assignee].presence
    }
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
