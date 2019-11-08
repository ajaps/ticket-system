module TicketsHelper
  def ticket_assign(ticket)
    return ticket.assignee.try(:name) if ticket.assignee.try(:name) && agent?

    render 'assigne_ticket', ticket: ticket
  end
end
