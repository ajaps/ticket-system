require 'rails_helper'

RSpec.describe 'User authentication', type: :feature do
  scenario "Can sign up" do
    visit root_path

    visit root_path
    click_on 'Sign up'

    password = Faker::Internet.password

    fill_in 'user_name', with: Faker::Name.name
    fill_in 'Email', with: Faker::Internet.email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password

    click_on 'Sign up'

    expect(page).to have_selector('.alert', text: 'Welcome! You have signed up successfully.')
  end

  scenario 'Can Login' do
    user = create(:user, email: 'current.user@email.com', password: 'password')

    visit root_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_on 'Log in'

    expect(page).to have_selector('.alert', text: 'Signed in successfully.')
  end

  scenario 'Can view profile' do
    user = create(:user, email: 'john.doe@email.com')
    sign_in user

    visit profile_path(user)

    expect(page).to_not have_content user.email
    expect(page).to_not have_content user.email
    expect(page).to have_selector('.list-group-item', text: "Tickets created\n#{ user.tickets.size }")
  end
end
