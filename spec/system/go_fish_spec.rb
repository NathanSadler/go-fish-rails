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

    let(:loaded_go_fish) {GoFish.load(Game.last.id)}

    it("displays the cards that the player has") do
      loaded_go_fish.players[0].send(:set_hand, [Card.new("3", "H")])
      loaded_go_fish.players[1].send(:set_hand, [Card.new("A", "D")])
      loaded_go_fish.deck.send(:set_cards, [Card.new("9", "S")])
      loaded_go_fish.save
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

    let(:loaded_go_fish) {GoFish.load(Game.last.id)}

    it("increments the go_fish's current_player_index after pressing the take "+
      "turn button") do
      loaded_go_fish.players[0].set_hand([Card.new("3", "D")])
      loaded_go_fish.players[1].set_hand([Card.new("7", "J")])
      loaded_go_fish.save
      session.visit(session.current_path)
      take_turn(session, "Michael Example", "3 of Diamonds")
      expect(GoFish.load(Game.last.id).turn_player.name).to(eq(loaded_go_fish.players[1].name))
    end

    describe("taking a card from the deck and giving it to the user") do
      before(:each) do
        loaded_go_fish.players[0].set_hand([Card.new("7", "S"), Card.new("Q", "D")])
        loaded_go_fish.players[1].set_hand([Card.new("7", "C")])
        loaded_go_fish.deck.send(:set_cards, [Card.new("4", "H")])
        loaded_go_fish.save
        session.visit(session.current_path)
        take_turn(session, "Michael Example", "7 of Spades")
      end

      let(:go_fish) {GoFish.load(Game.last.id)}

      it("takes a card from the deck and adds it to the user's hand when their" +
      " turn is over") do
        take_turn(session, "Michael Example", "7 of Spades")
        expect(go_fish.players[0].hand.include?(Card.new("4", "H"))).to(be(true))
        expect(go_fish.deck.empty?).to(be(true))
      end

      it("lets one user ask for and take card(s) from another") do
        expect(go_fish.players[0].hand.include?(Card.new("7", "C"))).to(be(true))
        expect(go_fish.players[1].hand.include?(Card.new("7", "C"))).to(be(false))
      end

      it("will still be the player's turn if they get a card from another player") do
        expect(go_fish.turn_player.name).to(eq(go_fish.players[0].name))
      end
    end
  end

end
