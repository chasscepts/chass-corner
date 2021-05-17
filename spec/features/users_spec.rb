require 'rails_helper'

feature 'User' do
  scenario 'creates a new User' do
    visit new_user_path
    fill_in 'name', with: 'Francis'
    click_button 'commit'
    expect(page).to have_text 'Your account was successfully setup'
  end

  scenario 'does not create a new account for already existing username' do
    user = User.create!(name: 'Francis')
    visit new_session_path
    fill_in 'name', with: user.name
    click_button 'commit'
    expect(page).not_to have_text 'Your account was successfully setup'
  end
end
