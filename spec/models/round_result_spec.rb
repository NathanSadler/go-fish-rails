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
      expect(test_round_result.source_name).to(eq("an unspecified source"))
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

  context('#source_name') do
    let(:test_round_result) {RoundResult.new(cards: test_card,
      recieving_player: test_player, source: Player.new("Joe"))}

    it("returns the name of a player if it is the source") do
      expect(test_round_result.source_name).to(eq("Joe"))
    end

    it("returns 'the deck' if the source is a deck") do
      test_round_result = RoundResult.new(cards: test_card,
        recieving_player: test_player, source: Deck.new)
      expect(test_round_result.source_name).to(eq("the deck"))
    end
  end

  context('#matched_rank?') do
    it("is true if there is a card with expected_rank rank in cards") do
      round_result = RoundResult.new(cards: Card.new("7", "H"),
      recieving_player: Player.new, expected_rank: "7")
      expect(round_result.matched_rank?).to(be(true))
    end

    it("is false if there isn't a card with expected_rank in cards") do
      round_result = RoundResult.new(cards: Card.new("7", "H"),
      recieving_player: Player.new, expected_rank: "8")
      expect(round_result.matched_rank?).to(be(false))
    end

    it("returns false if no cards are won") do
      round_result = RoundResult.new(cards: [],
      recieving_player: Player.new, expected_rank: "8")
      expect(round_result.matched_rank?).to(be(false))
    end
  end

  context('#hidden_message') do
    it("returns a message in the form 'you took <x> <y>(s) from <z>'") do
      round_result = RoundResult.new(cards: test_card,
        recieving_player: test_player, source: Player.new("Seth"))
      expected_message = "You took 1 7(s) from Seth"
      expect(round_result.hidden_message).to(eq(expected_message))
    end

    it("returns 'You took no cards' if cards is empty") do
      round_result = RoundResult.new(cards: [],
        recieving_player: test_player, source: Player.new("Seth"))
      expect(round_result.hidden_message).to(eq("You took no cards"))
    end
  end

  context('#public_message') do
    it("displays the recieved cards if the card rank matches the requested "+
    "rank") do
      round_result = RoundResult.new(cards: Card.new("3", "S"), expected_rank: "3",
        recieving_player: Player.new("Bert"), source: Player.new("Ernie"))
      expected_message = "Bert took 1 3(s) from Ernie"
      expect(round_result.public_message).to(eq(expected_message))
    end

    it("hides the rank of the recieved cards if the card rank doesn't match "+
    "the requested rank") do
      round_result = RoundResult.new(cards: Card.new("3", "S"), expected_rank: "9",
        recieving_player: Player.new("Bert"), source: Player.new("Ernie"))
      expected_message = "Bert took 1 card(s) from Ernie"
      expect(round_result.public_message).to(eq(expected_message))
    end
  end
end
