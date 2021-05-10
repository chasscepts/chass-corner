require 'rails_helper'
require_relative '../support/shared/session'

feature 'Session' do
  scenario 'creates a new session for registered user name' do
    user = User.create!(name: 'Francis')
    login user.name
    expect(page).to have_text 'You are successfully logged in'
  end

  scenario 'does not create a new session for wrong username' do
    login 'Francis'
    expect(page).not_to have_text 'You are successfully logged in'
  end

  scenario 'correctly logs a user out' do
    user = User.create!(name: 'Francis')
    login user.name

    click_link 'Sign Out'
    expect(page).to have_text 'Please Log in to continue'
  end
end
