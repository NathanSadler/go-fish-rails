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

RSpec.describe "Game", type: :system do

  let(:session) {Capybara::Session.new(:rack_test, Rails.application)}
  let(:session2) {Capybara::Session.new(:rack_test, Rails.application)}

  before(:each) do
    User.create(name:"foobar", email:"foo@bar.com", password:"foobar",
      password_confirmation:"foobar")
    login(session)
    login(session2, "michael@example.com", "password")
  end

  after(:each) do
    User.destroy_all
  end

  describe("creating a game") do
    it("lets users create new games") do
      session.visit new_game_path
      create_game(session, "Automated Test Game", 2)
      expect(session.body).to(have_content("Automated Test Game"))
    end

    it("takes users to the show page of the game they just created") do
      create_game(session)
      expect(session.current_path).to(eq("/games/#{Game.last.id}"))
    end
  end

  describe("starting a game") do
    it("creates a timestamp for when the game was started") do
      login(session)
      create_game(session, "Who cares?", 1)
      session.click_on("Join Game")
      expect(Game.last.started_at.nil?).to(be(false))
    end
  end

  describe("joining a game") do
    it("creates a GameUser object for this game and user if one doesn't " +
    "already exist") do
      create_game(session)
      session.click_on "Join Game"
      last_gameuser = GameUser.last
      expect(last_gameuser.game_id).to(eq(Game.last.id))
      expect(last_gameuser.user_id).to(eq(User.last.id))
    end
  end

  describe("showing a game") do
    it("shows a waiting_room page when there aren't enough players "+
    "in the game") do
      create_game(session)
      session.click_on "Join Game"
      expect(session.body).to(have_content("Waiting for game to start"))
    end

    it("lists all players in the game in the waiting room") do
      create_game(session, "Automatic Test Game", 3)
      session.click_on "Join Game"
      session2.visit("/games/#{Game.last.id}")
      session2.click_on("Join Game")
      expect(session2.body).to(have_content("foobar"))
    end

    it("displays the main game view when the game has enough players and the "+
    "user has joined the game") do
      create_game(session, "Auto Test", 2)
      session.click_on "Join Game"
      session2.visit("/games/#{Game.last.id}")
      session2.click_on("Join Game")
      expect(session2.body).to(have_content("Wait Your Turn"))
    end
  end

end
