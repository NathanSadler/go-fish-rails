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

RSpec.describe "GoFish", type: :system do

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

  describe("edit/updating a game") do
    before(:each) do
      create_game(session, "Aught O Test", 2)
      session.click_on "Join Game"
      session2.visit("/games/#{Game.last.id}")
      session2.click_on "Join Game"
      session.visit current_path
    end

    describe("the Take Turn button") do
      it("increments the go_fish's current_player_index after pressing it") do
        session.click_on "Take Turn"
        loaded_go_fish = GoFish.load(Game.last.id)
        expect(loaded_go_fish.turn_player).to(eq(loaded_go_fish.players[1]))
      end
    end
  end

end
