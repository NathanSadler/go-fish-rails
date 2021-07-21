require 'rails_helper'

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
  
  let(:game) {Game.last}

  describe("showing a game") do
    before(:each) do
      create_game(session, "Ah, Toe Test", 2)
      session.click_on "Join Game"
      session2.visit("/games/#{Game.last.id}")
      session2.click_on "Join Game"
      session.visit current_path
    end
    
    it("displays the cards that the player has") do
      game.go_fish.players[0].set_hand([Card.new("3", "H")])
      game.go_fish.players[1].set_hand([Card.new("A", "D")])
      game.go_fish.deck.send(:set_cards, [Card.new("9", "S")])
      game.save!
      session.visit(session.current_path)
      take_turn(session, "Michael Example", "3 of Hearts")
      expect(session.body).to(have_content("9 of Spades"))
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
      game.go_fish.players[0].set_hand([Card.new("3", "D")])
      game.go_fish.players[1].set_hand([Card.new("7", "H")])
      game.save!
      session.visit current_path
      take_turn(session, "Michael Example", "3 of Diamonds")
      expect(game.turn_player.name).to(eq(game.players[0].name))
    end

    describe("taking a card from the deck and giving it to the user") do
      before(:each) do
        game.go_fish.players[0].set_hand([Card.new("7", "S"), Card.new("Q", "D")])
        game.go_fish.players[1].set_hand([Card.new("7", "C"), Card.new("4", "S")])
        game.go_fish.deck.send(:set_cards, [Card.new("4", "H")])
        game.save!
        session.visit(session.current_path)
        take_turn(session, "Michael Example", "7 of Spades")
      end

      it("takes a card from the deck and adds it to the user's hand when their" +
      " turn is over") do
        game.go_fish.deck.send(:set_cards, [Card.new("4", "H")])
        game.save!
        take_turn(session, "Michael Example", "7 of Spades")

        updated_game = Game.last
        expect(updated_game.go_fish.players[0].hand.include?(Card.new("4", "H"))).to(be(true))
        expect(updated_game.go_fish.deck.empty?).to(be(true))
      end

      it("won't try to draw a card if the deck is empty") do
        take_turn(session, "Michael Example", "Queen of Diamonds")
        expect(Game.last.go_fish.players[0].hand.length).to(eq(4))
        expect(Game.last.turn_player.name).to(eq("Michael Example"))
      end
      

      it("lets one user ask for and take card(s) from another") do
        expect(game.players[0].hand.include?(Card.new("7", "C"))).to(be(false))
        expect(game.players[1].hand.include?(Card.new("7", "C"))).to(be(true))
      end

      it("will still be the player's turn if they get a card from another player") do
        expect(game.turn_player.name).to(eq(game.players[0].name))
      end
    end
  end
end
