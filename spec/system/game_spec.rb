require 'rails_helper'

RSpec.describe "Game", type: :system do
  [:session, :session2, :userless_session].each {|user_session| let(user_session) {Capybara::Session.new(:rack_test, Rails.application)}}

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

    it("doesn't let a user create a game if they aren't logged in") do
      previous_game_count = Game.all.length
      create_game(userless_session)
      expect(Game.all.length).to(eq(previous_game_count))
    end
  end

  describe("starting a game") do
    before(:each) do
      create_game(session, "Who cares?", 2)
      session.click_on("Join Game")
      session2.visit("/games/#{Game.last.id}")
      session2.click_on("Join Game")
      session.click_on("Try To Start Game")
    end

    it("creates a timestamp for when the game was started") do
      expect(Game.last.started_at.nil?).to(be(false))
    end

    it("deals the deck of cards") do
      game = Game.last
      comparison_deck = Deck.new
      expect(game.go_fish.deck.cards_in_deck).to(eq(
        Deck.cards_in_default_deck - (InitialCardsPerPlayer::FEW_PLAYERS * 2)))
    end
  end

  describe("joining a game") do
    before(:each) do
      create_game(session)
      session.click_on("Join Game")
    end

    let(:last_gameuser) {GameUser.last}

    it("creates a GameUser object for this game and user if one doesn't " +
    "already exist") do
      expect(last_gameuser.game_id).to(eq(Game.last.id))
      expect(last_gameuser.user_id).to(eq(User.last.id))
    end

    it("adds a Player object to the game for the GameUser that is joining") do
      game = Game.last
      expect(game.players.map(&:user_id).include?(last_gameuser.user_id)).to(eq(true))
    end

    it("doesn't let a user join a game if they aren't logged in") do
      game = Game.last
      join_game(userless_session, game.id)
      expect(game.players.length).to(eq(1))
    end
  end

  describe("showing a game") do
    it("shows a waiting_room page when there aren't enough players "+
    "in the game") do
      create_game(session)
      session.click_on "Join Game"
      expect(session.body).to(have_content("Waiting for game to start"))
      session.click_on("Try To Start Game")
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
      join_game_from_info_page(session)
      join_game(session2, Game.last.id)
      [session, session2].each {|user_session| start_game(user_session)}
      expect(session2.body).to(have_content("Wait Your Turn"))
    end

    it("displays the take_turn page when it is the user's turn") do
      create_game(session, "Otto Test", 1)
      join_game_from_info_page(session)
      start_game(session)
      expect(session.body).to(have_content("Take Your Turn"))
    end

    describe("displaying round results") do
      let(:game) {Game.last} 
      before(:each) do
        create_game(session, "Ah! Toe Test!", 2)
        session2.visit("/games/#{Game.last.id}")
        [session, session2].each {|user_session| user_session.click_on("Join Game")}
        game.go_fish.players[0].set_hand([Card.new("4", "D")])
        game.go_fish.players[1].set_hand([Card.new("9", "S"), Card.new("8", "C")])
        game.save!
        [session, session2].each {|user_session| start_game(user_session)}
      end

      it("displays round results on the waiting_to_take_turn and taking_turn pages") do
        game.go_fish.deck.send(:set_cards, [Card.new("10", "H")])
        game.save!
        session.visit(current_path)
        take_turn(session, "Michael Example", "4 of Diamonds")
        expect(session.body).to(have_content("took 1"))
        session2.click_on("Try To Take Turn")
        expect(session2.body).to(have_content("took 1"))
      end

      it("only displays the hidden message if the player is the same as the round result's recieving player") do
        game.go_fish.deck.send(:set_cards, [Card.new("10", "H")])
        game.save!
        session.visit(current_path)
        take_turn(session, "Michael Example", "4 of Diamonds")
        expect(session.body).to(have_content("took 1 10(s) from the deck"))
        session2.click_on("Try To Take Turn")
        expect(session2.body).to_not(have_content("took 1 10(s)"))
      end

    end
  end

end
