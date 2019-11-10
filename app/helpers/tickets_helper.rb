module TicketsHelper
  def ticket_assign(ticket)
    return render 'assigne_ticket', ticket: ticket if super_user?

    return ticket.assignee.try(:name) if ticket.assignee.try(:name)
  end
end
