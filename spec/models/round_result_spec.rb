require 'rails_helper'

RSpec.describe RoundResult do
  let(:test_card) {Card.new("7", "H")}
  let(:test_player) {Player.new}
  let(:test_asked_player) {Player.new("Test Asked Player")}
  let(:test_round_result) {RoundResult.new(cards: test_card,
    recieving_player: test_player, asked_player: test_asked_player)}

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
        recieving_player: test_player, expected_rank: 8, asked_player: test_asked_player)
      expect(test_round_result.expected_rank).to(eq("8"))
    end
  end

  context('#as_json') do
    let(:test_round_result) {RoundResult.new(cards: test_card,
      recieving_player: Player.new("Tim Emerald"), source: Player.new("John Ruby"),
      expected_rank: "6", asked_player: test_asked_player)}
    let(:json_round_result) {test_round_result.as_json}

    it("returns a hash with the cards") do
      expect(json_round_result['cards']).to(eq([{"rank" => "7", "suit" => "H"}]))
    end

    it("returns a hash with the recieving_player") do
      recieving_player_name = json_round_result['recieving_player']['name']
      expect(recieving_player_name).to(eq("Tim Emerald"))
    end

    it("returns a hash with the expected_rank") do
      expect(json_round_result['expected_rank']).to(eq("6"))
    end

    it("returns a hash with the source's name") do
        expect(json_round_result['source']).to(eq("John Ruby"))
    end
  end

  context('#from_json') do
    let(:test_round_result) {RoundResult.new(cards: test_card,
      recieving_player: Player.new("Tim Emerald"), source: Player.new("John Ruby"),
      expected_rank: "6", asked_player: Player.new("John Ruby"))}
    let(:json_round_result) {test_round_result.as_json}

    it("makes a round result from a json hash") do
      restored_round_result = RoundResult.from_json(json_round_result)
      expect(restored_round_result.cards).to(eq([test_card]))
      expect(restored_round_result.expected_rank).to(eq("6"))
      expect(restored_round_result.recieving_player.name).to(eq("Tim Emerald"))
      expect(restored_round_result.source).to(eq("John Ruby"))
    end
  end

  context('#source_name') do
    let(:test_round_result) {RoundResult.new(cards: test_card,
      recieving_player: test_player, source: Player.new("Joe"), asked_player: Player.new("Joe"))}

    it("returns the name of a player if it is the source") do
      expect(test_round_result.source_name).to(eq("Joe"))
    end

    it("returns 'the deck' if the source is a deck") do
      test_round_result = RoundResult.new(cards: test_card,
        recieving_player: test_player, source: Deck.new, asked_player: test_asked_player)
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

  context('#message_start') do
    it("returns the portion of the message that will be the same no matter who views it") do
      round_result = RoundResult.new(cards: Card.new("7", "H"),
      recieving_player: Player.new, expected_rank: "7", source: Player.new("Pain"), asked_player: Player.new("Pain"))
      expect(round_result.message_start).to(eq("Player asked Pain for 7s"))
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
        recieving_player: Player.new("Bert"), source: Player.new("Ernie"), asked_player: Player.new("Ernie"))
      expected_message = "Bert asked Ernie for 3s and took 1 3(s)"
      expect(round_result.public_message).to(eq(expected_message))
    end

    it("hides the rank of the recieved cards if the card rank doesn't match "+
    "the requested rank") do
      round_result = RoundResult.new(cards: Card.new("3", "S"), expected_rank: "9",
        recieving_player: Player.new("Bert"), source: Player.new("Ernie"), asked_player: Player.new("Ernie"))
      expected_message = "Bert asked Ernie for 9s and took 1 card(s)"
      expect(round_result.public_message).to(eq(expected_message))
    end
  end
end
