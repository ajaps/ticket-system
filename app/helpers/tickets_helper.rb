module TicketsHelper
  def ticket_assign(form, ticket)
    return render 'assigne_ticket', ticket: ticket, f: form if super_user?

    return ticket.assignee.try(:name) if ticket.assignee.try(:name)
  end
end
