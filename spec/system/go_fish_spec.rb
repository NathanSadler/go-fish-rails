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

  describe("showing a game") do
    before(:each) do
      create_game(session "Ah, Toe Test", 2)
      session.click_on "Join Game"
      session2.visit("/games/#{Game.last.id}")
      session2.click_on "Join Game"
      session.visit current_path
    end

    it("displays the cards that the player has") do
      loaded_go_fish = GoFish.load(Game.last.id)
      loaded_go_fish.players[0].send(:set_hand, [])
      #load
    end
  end

  describe("edit/updating a game") do
    before(:each) do
      create_game(session, "Aught O Test", 2)
      session.click_on "Join Game"
      session2.visit("/games/#{Game.last.id}")
      session2.click_on "Join Game"
      session.visit current_path
    end

    it("increments the go_fish's current_player_index after pressing the take "+
      "turn button") do
      session.click_on "Take Turn"
      loaded_go_fish = GoFish.load(Game.last.id)
      expect(loaded_go_fish.turn_player).to(eq(loaded_go_fish.players[1]))
    end

    describe("taking a card from the deck and giving it to the user") do
      before(:each) do
        loaded_go_fish = GoFish.load(Game.last.id)
        loaded_go_fish.players[0].set_hand([])
        loaded_go_fish.deck.send(:set_cards, [Card.new("4", "H")])
        loaded_go_fish.save
      end

      it("takes a card from the deck and adds it to the user's hand when their" +
      " turn is over") do
        session.click_on "Take Turn"
        loaded_go_fish = GoFish.load(Game.last.id)
        expect(loaded_go_fish.players[0].hand).to(eq([Card.new("4", "H")]))
        expect(loaded_go_fish.deck.empty?).to(be(true))
      end
    end
  end

end
