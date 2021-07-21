require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:session1) {Capybara::Session.new(:rack_test, Rails.application)}
  let(:last_game) {Game.create}



  describe("try_to_start") do
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
        binding.pry
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
