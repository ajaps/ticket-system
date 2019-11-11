require 'rails_helper'

RSpec.describe 'User actions on Ticket', type: :feature do
  scenario 'Create Ticket' do
    user = create(:user)
    sign_in user

    visit root_path
    click_on 'Create Ticket'

    select('High', from: 'ticket_priority')
    fill_in 'Title', with: Faker::Lorem.sentences(number: 4).join(' ')
    fill_in 'Text', with: Faker::Lorem.sentences(number: 50).join(' ')

    expect{
      click_button 'Create Ticket'
    }.to change(Ticket, :count).by(1)

    expect(page).to have_content('less than a minute ago')
    expect(page).to have_content('Ticket Status')
    expect(page).to have_content('Open')
  end
end
