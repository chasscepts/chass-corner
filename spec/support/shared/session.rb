require 'rails_helper'

def login(name)
  visit new_session_path
  fill_in 'name', with: name
  click_button 'commit'
end
