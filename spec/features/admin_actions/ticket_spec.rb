require 'rails_helper'

RSpec.describe 'Admin actions on Ticket', type: :feature do
  scenario 'Change priority' do
    user = create(:user)
    admin = create(:user, :admin)
    ticket = create(:ticket, user_id: user.id)

    sign_in admin

    visit root_path
    click_on ticket.title

    select('Critical', from: 'ticket_priority')
    click_button 'Update'

    expect(page).to have_selector('.alert', text: 'Ticket was successfully updated')
  end

  scenario 'Change priority' do
    user = create(:user)
    agent = create(:user, :agent)
    admin = create(:user, :admin)
    create(:ticket, user_id: user.id)

    sign_in admin

    visit root_path

    select(agent.name, from: 'ticket_assignee_id')
    click_button 'Update'

    expect(page).to have_content("Assigned to: #{agent.name}")
    expect(page).to have_selector('.alert', text: 'Ticket was successfully updated')
  end

  scenario 'Delete ticket' do
    user = create(:user)
    admin = create(:user, :admin)
    create(:ticket, user_id: user.id)

    sign_in admin

    visit root_path

    click_link 'Delete'
    page.accept_alert

    expect(page).to have_selector('.alert', text: 'Ticket was deleted successfully')
  end
end
