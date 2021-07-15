require 'rails_helper'

# def login
#   visit login_path
#   fill_in 'Email', with: "foo@bar.com"
#   fill_in "Password", with: "foobar"
#   click_on "Submit"
# end

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

RSpec.describe "Game", type: :system do
  before(:each) do
    User.create(name:"foobar", email:"foo@bar.com", password:"foobar",
      password_confirmation:"foobar")
  end

  after(:each) do
    User.destroy_all
  end

  let(:session) {Capybara::Session.new(:rack_test, Rails.application)}

  describe("creating a game") do
    it("lets users create new games") do
      login(session)
      session.visit new_game_path
      create_game(session, "Automated Test Game", 2)
      expect(session.body).to(have_content("Automated Test Game"))
    end

    it("takes users to the show page of the game they just created") do
      login(session)
      create_game(session)
      expect(session.current_path).to(eq("/games/#{Game.last.id}"))
    end
  end

  describe("joining a game") do
    it("creates a GameUser object for this game and user if one doesn't " +
    "already exist") do
      login(session)
      create_game(session)
      session.click_on "Join Game"
      last_gameuser = GameUser.last
      expect(last_gameuser.game_id).to(eq(Game.last.id))
      expect(last_gameuser.user_id).to(eq(User.last.id))
    end

    it("shows a waiting_room page when there aren't enough players "+
    "in the game") do
      login(session)
      create_game(session)
      session.click_on "Join Game"
      expect(session.body).to(have_content("Waiting for game to start"))
    end
  end

end
