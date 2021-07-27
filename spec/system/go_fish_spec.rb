require 'rails_helper'

RSpec.describe "GoFish", type: :system do
  let(:session) {Capybara::Session.new(:rack_test, Rails.application)}
  let(:session2) {Capybara::Session.new(:rack_test, Rails.application)}
  let(:session3) {Capybara::Session.new(:rack_test, Rails.application)}

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

  describe("starting a game") do
    before(:each) do
      create_game(session, "Ah, Toe Test", 2)
      session.click_on "Join Game"
      session2.visit("/games/#{Game.last.id}")
      session2.click_on "Join Game"
    end

    it("deals cards to all players in the game") do
      session.click_on "Try To Start Game"
      Game.last.go_fish.players.each {|player| expect(player.number_of_cards).to(eq(7))}
    end

    it("doesn't send people into the game if they refresh in the waiting room") do
      session.visit(session.current_path)
      expect(session.body).to(have_content("Waiting for game to start..."))
    end

    context("with more than 2 players") do
      before(:each) do
        new_user = User.create(name: "hyperfoobar", email: "hyper@foobar.com", password: "hyperfoobar", password_confirmation: "hyperfoobar")
        login(session3, new_user.email, new_user.password)
        create_game(session, "Hope This Works!", 3)
        [session2, session3].each {|user| user.visit("/games/#{Game.last.id}")}
        [session, session2, session3].each {|user| user.click_on("Join Game")}
        [session, session2].each {|user| user.click_on("Try To Start Game")}
      end

      it("doesn't deal cards more than once") do
        go_fish_players = Game.last.go_fish.players
        go_fish_players.each {|player| expect(player.hand.length).to(eq(7))}
      end
    end
  end

  describe("showing a game") do
    before(:each) do
      create_game(session, "Ah, Toe Test", 2)
      session.click_on "Join Game"
      session2.visit("/games/#{Game.last.id}")
      session2.click_on "Join Game"
      session.click_on "Try To Start Game"
    end

    describe("running out of cards during a turn") do
      before(:each) do
        game.go_fish.players[0].set_hand([Card.new("2", "C"), Card.new("2", "S")])
        game.go_fish.players[1].set_hand([Card.new("2", "D"), Card.new("2", "H"), Card.new("3", "H")])
        game.go_fish.deck.send(:set_cards, [Card.new("4", "H")])
        game.save!
        session.visit(current_path)
        take_turn(session, "Michael Example", "2 of Clubs")
      end

      it("automatically draws a card from the deck") do
        expect(Game.last.go_fish.players[0].has_card?(Card.new("4", "H"))).to(be(true))
        expect(Game.last.go_fish.deck.empty?).to(be(true))
      end

      it("moves to the next player's turn") do
        expect(Game.last.go_fish.turn_player.name).to(eq("Michael Example"))
        expect(session.body).to(have_content("Wait Your Turn"))
      end
    end

    describe("showing the game over screen") do
      before(:each) do
        game.go_fish.players[0].set_hand([Card.new("2", "C"), Card.new("2", "S")])
        game.go_fish.players[1].set_hand([Card.new("2", "D"), Card.new("2", "H")])
        game.go_fish.deck.send(:set_cards, [])
        game.save!
        session.visit(current_path)
        take_turn(session, "Michael Example", "2 of Clubs")
      end

      it("is displayed when the game is finished") do
        expect(session.body).to(have_content("Game Over"))
      end

      it("says who the winner is") do
        expect(session.body).to(have_content("foobar won!"))
      end
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
      start_game(session)
    end

   

    describe("giving a player a card at the start of a turn") do
      it("if there are cards in the deck and the player doesn't have any cards") do
        game.go_fish.send(:set_current_player_index, 1)
        game.go_fish.players[0].set_hand([])
        game.go_fish.deck.send(:set_cards, [Card.new("8", "D")])
        game.go_fish.next_player
        game.save!
        session.visit current_path
        expect(session.has_field?("8 of Diamonds", type: 'radio')).to(eq(true))
      end

      it("doesn't happen if the player does have any cards") do
        game.go_fish.players[0].set_hand([Card.new("9", "D")])
        game.go_fish.deck.send(:set_cards, [Card.new("10", "D")])
        game.save!
        session.visit current_path
        expect(session.has_field?("10 of Diamonds", type: 'radio')).to(eq(false))
      end
    end

    it("skips a player's turn if they have no cards AND there aren't any cards in the deck") do
      game.go_fish.players[0].set_hand([Card.new("2", "C")])
      game.go_fish.players[1].set_hand([])
      game.go_fish.deck.send(:set_cards, [])
      game.save!
      session.visit current_path
      take_turn(session, "Michael Example", "2 of Clubs")
      expect(session).to(have_content("Take Your Turn"))
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

RSpec.describe "GoFish (auto updating pages)", type: :system, js: true do
  let(:session1) {Capybara::Session.new(:selenium_chrome_headless, Rails.application)}
  let(:session2) {Capybara::Session.new(:selenium_chrome_headless, Rails.application)}
  let(:session3) {Capybara::Session.new(:selenium_chrome_headless, Rails.application)}

  context("updating the round results without reloading") do
    before(:each) do
      user = User.create(name:"whatisgoingon", email: "whatis@goingon.com", password: "seriouslywhat", password_confirmation: "seriouslywhat")
      user3 = User.create(name:"superfoobar", email:"superfoo@bar.com", password:"superbarfoo", password_confirmation:"superbarfoo")
      [[session1, "whatis@goingon.com", "seriouslywhat"], [session2, "michael@example.com", "password"]].each {|info| login(info[0], info[1], info[2])}
      login(session3, user3.email, user3.password)
      create_game(session1, "not headless test", 3)
      [session2, session3].each {|session| session.visit("/games/#{Game.last.id}")}
      [session1, session2, session3].each {|session| session.click_on "Join Game"}
    end

    it("automatically adds players to the list of players in the lobby when they join") do
      expect(session1.body).to(have_content("whatisgoingon"))
      expect(session1.body).to(have_content("superfoobar"))
    end

    context("automatically updating card lists and round results") do
      let(:last_game) { Game.last }
      
      before(:each) do
        [session1, session2, session3].each {|session| session.click_on("Try To Start Game")}
        go_fish = Game.last.go_fish
        go_fish.players[0].set_hand([Card.new("7", "H"), Card.new("8", "H")])
        go_fish.players[1].set_hand([Card.new("7", "S"), Card.new("9", "S")])
        go_fish.players[2].set_hand([Card.new("10", "H"), Card.new("J", "H")])
        Game.last.update(go_fish: go_fish)
        session1.refresh
        take_turn(session1, "Michael Example", "7 of Hearts")
      end

      # This fails every so often, but it works in the browser. No idea what the problem is.
      it("updates the round results") do
        expect(session2.has_content?("whatisgoingon asked Michael Example for 7s and took 1 7(s)")).to(be(true))
        expect(session2.has_content?("4")).to(be(false))
        expect(session2.has_content?("3")).to(be(false))
      end

      it("updates the list of cards") do
        expect(session2.has_content?("7 of Spades")).to(be(false))
      end

      it("won't show a player a different player's hand or cards") do
        expect(session3.has_content?("9 of Spades")).to(be(false))
        expect(session2.has_content?("10 of Hearts")).to(be(false))
      end

    end
  end
end
