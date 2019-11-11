require 'rails_helper'

RSpec.describe 'Agent actions on Ticket', type: :feature do
  feature 'Agent' do
    scenario 'can add comments to ticket' do
      user = create(:user)
      agent = create(:user, :agent)
      ticket = create(:ticket, user_id: user.id)

      sign_in agent
      visit root_path
      click_on ticket.title
      fill_in 'comment_text', with: 'We are lookinh into this, an update would be provided shortly'
      click_on 'Send'

      expect(page).to have_selector('.alert', text: 'Comment was saved successfully')
    end

    scenario 'can assign ticket to self' do
      user = create(:user)
      agent = create(:user, :agent)
      create(:ticket, user_id: user.id)

      sign_in agent
      visit root_path
      click_on 'Assign to me'

      expect(page).to have_selector('.alert', text: 'Ticket was successfully updated')
      expect(page).to have_content("Assigned to: #{agent.name}")
    end
  end
end
