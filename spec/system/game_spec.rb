require 'rails_helper'

def login
  visit login_path
  fill_in 'Email', with: "foo@bar.com"
  fill_in "Password", with: "foobar"
  click_on "Submit"
end

def create_game(game_name = "Test Game", player_count = 2)
  visit new_game_path
  fill_in 'Game Title', with: game_name
  fill_in 'Minimum Number of Players', with: player_count.to_s
  click_on "Submit"
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
    create_game("Automated Test Game", 2)
    expect(page).to(have_content("Automated Test Game"))
  end
end

RSpec.describe 'Game#show', type: :system do
  before(:each) do
    User.create(name:"foobar", email:"foo@bar.com", password:"foobar",
      password_confirmation:"foobar")
  end

  after(:each) do
    User.destroy_all
  end
  
  it("shows a waiting_room page when there aren't enough players "+
  "in the game") do
    login
    visit new_game_path
    fill_in 'Title', with: "Automated Test Game"
    click_on "Submit"
    expect(page)
  end
end

RSpec.describe 'Game#new', type: :system do
  before(:each) do
    User.create(name:"foobar", email:"foo@bar.com", password:"foobar",
      password_confirmation:"foobar")
  end

  after(:each) do
    User.destroy_all
  end

  it("takes users to the show page of the game they just created") do
    login
    create_game
    expect(current_path).to(eq("/games/#{Game.last.id}"))
  end
end
