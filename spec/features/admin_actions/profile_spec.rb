require 'rails_helper'

RSpec.describe 'Admin actions on Profile', type: :feature do
  scenario 'Set user as Agent' do
    user = create(:user, name: 'john-doe')
    create(:user, :agent)
    admin = create(:user, :admin)

    sign_in admin

    visit root_path
    click_link 'Admin Panel'

    user_identifier = "#{ user.name }-#{ user.id }"
    select('true', from: "agent-#{ user_identifier }")
    click_button "update-#{ user_identifier }"
    click_link user_identifier

    expect(page).to have_content("Support Staff")
  end

  scenario 'Deleting a profile' do
    user = create(:user, name: 'john-doe')
    admin = create(:user, :admin)

    sign_in admin

    visit root_path
    click_link 'Admin Panel'

    user_identifier = "#{ user.name }-#{ user.id }"
    click_link "delete-#{ user_identifier }"
    page.accept_alert

    expect(page).to have_selector('.alert', text: 'User account was deleted succesfully')
  end
end
