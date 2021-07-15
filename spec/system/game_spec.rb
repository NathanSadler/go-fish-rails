require 'rails_helper'

def login
  visit login_path
  fill_in 'Email', with: "foo@bar.com"
  fill_in "Password", with: "foobar"
  click_on "Submit"
end

def create_game(game_name = "Test Game", player_count = 2)
  visit new_game_path
  fill_in 'Title', with: game_name
  fill_in
end

RSpec.describe "Game", type: :system do
  before(:each) do
    User.create(name:"foobar", email:"foo@bar.com", password:"foobar",
      password_confirmation:"foobar")
  end

  after(:each) do
    User.destroy_all
  end

  scenario("a logged in user creates a game") do
    login
    visit new_game_path
    fill_in 'Title', with: "Automated Test Game"
    click_on "Submit"
    expect(page).to(have_content("Automated Test Game"))
  end
end

RSpec.describe 'Game#show', type: :system do
  it("shows a waiting_room page when there aren't enough players "+
  "in the game") do
    login
    visit new_game_path
    fill_in 'Title', with: "Automated Test Game"
    click_on "Submit"
    expect(page)
  end
end
