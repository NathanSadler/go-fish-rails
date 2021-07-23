require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:session1) {Capybara::Session.new(:rack_test, Rails.application)}
  let(:last_game) {Game.create}

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
      bar = GameUser.create(game_id: Game.last.id, user_id: User.last.id)
    end

    it("returns an array containing the user that have joined the game") do
      expect(Game.last.users.map(&:name)).to(eq(["blank"]))
    end
  end

  describe("#try_to_start") do
    before(:each) do
      GameUser.create(game_id: last_game.id, user_id: User.last.id)
      game = Game.last
      game.add_player(Player.new)
      game.started_at = nil
    end

    let(:game) {Game.last}

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
        expect(game.players[0].hand.length).to(eq(0))
      end

      it("doesn't set started_at") do
        expect(last_game.started_at.nil?).to(be(true))
      end
    end
  end

end
