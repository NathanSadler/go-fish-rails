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

  describe("showing a game") do
    before(:each) do
      create_game(session, "Ah, Toe Test", 2)
      session.click_on "Join Game"
      session2.visit("/games/#{Game.last.id}")
      session2.click_on "Join Game"
      session.visit current_path
    end

    let(:game) {Game.last}

    it("displays the cards that the player has") do
      game.set_player_hand(0, [Card.new("3", "H")])
      game.set_player_hand(1, [Card.new("A", "D")])
      game.set_deck([Card.new("9", "S")])
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

    let(:game) {Game.last}

    it("increments the go_fish's current_player_index after pressing the take "+
      "turn button") do
      game.set_player_hand(0, [Card.new("3", "D")])
      game.set_player_hand(1, [Card.new("7", "H")])
      session.visit current_path
      take_turn(session, "Michael Example", "3 of Diamonds")
      expect(game.turn_player.name).to(eq(game.players[1].name))
    end

    describe("taking a card from the deck and giving it to the user") do
      before(:each) do
        game.set_player_hand(0, [Card.new("7", "S"), Card.new("Q", "D")])
        game.set_player_hand(1, [Card.new("7", "C"), Card.new("4", "S")])
        game.set_deck([Card.new("4", "H")])
        session.visit(session.current_path)
        take_turn(session, "Michael Example", "7 of Spades")
      end

      let(:game) {Game.last}

      it("takes a card from the deck and adds it to the user's hand when their" +
      " turn is over") do
        game.set_deck([Card.new("4", "H")])
        take_turn(session, "Michael Example", "7 of Spades")
        expect(game.players[1].hand.include?(Card.new("4", "H"))).to(be(true))
        expect(game.deck.empty?).to(be(true))
      end

      it("lets one user ask for and take card(s) from another") do
        expect(game.players[0].hand.include?(Card.new("7", "C"))).to(be(true))
        expect(game.players[1].hand.include?(Card.new("7", "C"))).to(be(false))
      end

      it("will still be the player's turn if they get a card from another player") do
        expect(game.turn_player.name).to(eq(game.players[0].name))
      end

      describe("handing scoring and books at the end of a turn") do
        before(:each) do
          user_id = game.players[0].user_id
          game.give_card_to_player_with_user_id(user_id, [Card.new("7", "D"),
            Card.new("7", "H")])
          take_turn(session, "Michael Example", "7 of Spades")
        end

        xit("removes books from a player's hand at the end of a turn") do
          expect(GoFish.load(Game.last.id).players[0].has_card_with_rank?("7")).to(eq(false))
        end

        xit("adds to the player's score when they end a turn with a book") do
          expect(GoFish.load(Game.last.id).players[0].score).to(eq(1))
        end
      end
    end
  end
end
