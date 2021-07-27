require 'rails_helper'
require 'date'

RSpec.describe Game, type: :model do
  let(:session1) {Capybara::Session.new(:rack_test, Rails.application)}
  let(:last_game) {Game.create}

  describe('.end') do
    before(:each) do
      Game.create
    end

    it("sets the finished_at column") do
      game = Game.last
      game.end
      expect(game.finished?).to(be(true))
    end

    describe("setting the is_game_winner column for the GameUsers") do
      before(:each) do
        game = Game.last
        go_fish = GoFish.new
        ["dododo", "reireirei", "mimimi"].each {|username| User.create(name: username, email: "#{username}@gmail.com", password: username, password_confirmation: username)}
        User.last(3).each {|user| GameUser.create(game_id: game.id, user_id: user.id)}
        User.last(3).each {|user| go_fish.add_player(Player.new(user.name, user.id))}
        go_fish.players[0..1].each {|player| player.send(:set_score, 24)}
        game.update(go_fish: go_fish)
      end

      it("sets the is_game_winner column to true for players who came in 1st") do
        game = Game.last
        game.end
        game_winners_ids = game.go_fish.winning_players.map(&:user_id)
        game_winners_ids.each {|winner_id| expect(GameUser.find_by(user_id: winner_id).is_game_winner).to(eq(true))}
      end

      xit("sets the is_game_winner column to false for players who didn't come in 1st") do
        
      end
    end
  end

  describe('.finished') do
    it("returns games that have their finished_at set") do
      last_game.update(finished_at: DateTime.current)
      last_game.save!
      expect(Game.finished.include?(last_game)).to(be(true))
    end

    it("doesn't return games that don't have their finished_at set") do
      expect(Game.finished.include?(last_game)).to(be(false))
    end
  end

  describe("#ready_to_start?") do
    before(:each) do
      last_game.update(minimum_player_count: 1)
    end

    it("is true when the number of GameUser objects associated with the game is at least the minimum_players") do
      GameUser.create(game_id: last_game.id, user_id: User.last.id)
      expect(last_game.ready_to_start?).to(be(true))
    end

    it("is false when the number of GameUser objects associated with the game is less than the minimum_players") do
      expect(last_game.ready_to_start?).to(be(false))
    end
  end

  describe("#started?") do
    it("is false if the started_at timestamp is nil") do
      last_game.update(started_at: nil)
      expect(last_game.started?).to(be(false))
    end

    it("is true if the started_at timestamp has been set") do
      last_game.update(started_at: DateTime.current)
      expect(last_game.started?).to(be(true))
    end
  end

  describe("#take_turn") do
    before(:each) do
      Game.create
    end

    it("sets finished_at if the game is over at the end of a turn") do
      go_fish = GoFish.new([Player.new("Test Player 1", 1), Player.new("Test Player 2", 2)])
      game = Game.last
      go_fish.players.each {|player| player.send(:set_hand, [Card.new("2", "H"), Card.new("2", "D")])}
      go_fish.deck.send(:set_cards, [])
      game.update(go_fish: go_fish)
      game.take_turn(game.players[0], requested_player: game.players[1], requested_rank: "2")
      game.save!
      expect(game.finished_at.present?).to(be(true))
    end
  end

  describe("#try_to_start") do
    before(:each) do
      GameUser.create(game_id: last_game.id, user_id: User.last.id)
      game = Game.last
      game.add_player(Player.new)
      game.started_at = nil
      game.save!
    end

    let!(:game) {Game.last}

    context("the game hasn't started yet and there are enough players") do
      before(:each) do
        game.update(minimum_player_count: 1, maximum_player_count: 1)
        game.try_to_start
      end

      it("shuffles the deck") do
        comparison_deck = Deck.new
        expect(game.go_fish.deck.cards).to_not(eq(comparison_deck.cards))
      end

      it("deals the cards") do
        player = game.players[0]
        expect(player.hand.length).to(eq(InitialCardsPerPlayer::FEW_PLAYERS))
      end

      it("sets started_at") do
        expect(game.started_at).to be_present
      end
    end

    context("there aren't enough players to start the game") do
      before(:each) do
        last_game.minimum_player_count = 2
        last_game.maximum_player_count = 2
        last_game.try_to_start
      end

      it("doesn't shuffle the deck") do
        expect(game.go_fish.deck.cards).to(eq(Deck.new.cards))
      end

      it("doesn't deal the cards") do
        expect(game.go_fish.players[0].hand.length).to(eq(0))
      end

      it("doesn't set started_at") do
        expect(game.started?).to(be(false))
      end
    end
  end

  describe("#users_turn?") do
    before(:each) do
      User.create(name: "Test User", email: "screaming@thevoid.com",
      password: "workingpastmidnight", password_confirmation: "workingpastmidnight")
      [User.first, User.last].each do |user|
        GameUser.create(game_id: last_game.id, user_id: user.id)
        last_game.go_fish.add_player(Player.new(user.name, user.id))
        last_game.save!
      end
    end

    it("is true if the provided user has the same id as the game's turn_player's user_id") do
      expect(last_game.users_turn?(User.first)).to(be(true))
    end

    it("is false if the provided user doesn't have the same ID as the game's turn player's user_id") do
      expect(last_game.users_turn?(User.last)).to(be(false))
    end
  end

  describe('#users') do
    before(:each) do
      foo = User.create(name: "blank", email: "bl@nk.com", password: "blankk", password_confirmation: "blankk")
      Game.create
      bar = GameUser.create(game_id: Game.last.id, user_id: User.last.id)
    end

    it("returns an array containing the user that have joined the game") do
      expect(Game.last.users.map(&:name)).to(eq(["blank"]))
    end
  end
end
