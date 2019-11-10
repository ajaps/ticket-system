require 'rails_helper'

RSpec.describe 'User actions on Ticket', type: :feature do
  feature 'Users' do
    scenario "cannot comment on tickets where a support agent hasn't commented" do
      user = create(:user)
      sign_in user

      visit root_path
      click_on 'Create Ticket'

      select('High', from: 'ticket_priority')
      fill_in 'Title', with: Faker::Lorem.sentences(number: 4).join(' ')
      fill_in 'Text', with: Faker::Lorem.sentences(number: 50).join(' ')

      expect(page).to_not have_content('send and close ticket')
      expect(page).to_not have_content('Add comment')
    end

    scenario 'can add comments when support agent has commented on a ticket' do
      user = create(:user)
      agent = create(:user, :agent)

      ticket = create(:ticket, user_id: user.id)
      create(:comment, user_id: agent.id, text: 'Agent commented', ticket_id: ticket.id)

      sign_in user

      visit root_path
      click_on ticket.title

      fill_in 'comment_text', with: 'Where are we on this?'

      click_on 'Send'

      expect(page).to have_selector('.alert', text: 'Comment was saved successfully')
    end
  end
end
