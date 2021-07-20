require 'rails_helper'

RSpec.describe RoundResult do
  let(:test_card) {Card.new("7", "H")}
  let(:test_player) {Player.new}
  let(:test_round_result) {RoundResult.new(cards: test_card,
    recieving_player: test_player)}

  context("initialize") do
    it("defaults to using 'none given' as the expected_rank") do
      expect(test_round_result.expected_rank).to(eq('none given'))
    end

    it("defaults to using 'an unspecified source' for the source") do
      expect(test_round_result.source).to(eq("an unspecified source"))
    end

    it("automatically converts single cards into an array") do
      expect(test_round_result.cards.is_a?(Array)).to(eq(true))
    end

    it("automatically converts expected_rank into a string") do
      test_round_result = RoundResult.new(cards: test_card,
        recieving_player: test_player, expected_rank: 8)
      expect(test_round_result.expected_rank).to(eq("8"))
    end
  end

  context('#source') do
    # let(:test_round_result {RoundResult.new(cards: test_card,
      # recieving_player: test_player))})
    it("returns the name of a player if it is the source") do

      # expect(test_round_result.source).to(eq("Player"))
    end

    it("returns 'the deck' if the source is a deck") do

    end
  end

  context('#matched_rank?') do
    it("is true if there is a card with expected_rank rank in cards") do

    end

    it("is false if there isn't a card with expected_rank in cards") do

    end
  end

  context('#hidden_message') do
    it("returns a message in the form 'you took <x> <y>(s) from <z>'") do

    end

    it("returns 'You took no cards' if cards is empty") do

    end
  end

  context('#public_message') do
    it("displays the recieved cards if the card rank matches the requested "+
    "rank") do

    end

    it("hides the rank of the recieved cards if the card rank doesn't match "+
    "the requested rank") do

    end
  end
end
