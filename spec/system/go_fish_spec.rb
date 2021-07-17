require 'rails_helper'

def login(session, email="foo@bar.com", password="foobar")
  session.visit login_path
  session.fill_in 'Email', with: email
  session.fill_in 'Password', with: password
  session.click_on "Submit"
end

def create_game(session, game_name = "Test Game", player_count = 2)
  session.visit new_game_path
  session.fill_in 'Game Title', with: game_name
  session.fill_in 'Minimum Number of Players', with: player_count.to_s
  session.click_on "Submit"
end
