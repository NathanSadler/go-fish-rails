require_relative '../../app/models/card'

RSpec.describe Card do
  context('on create') do
    let(:card) { Card.new("4", "S") }

    it("creates a card with a specified rank") do
      expect(card.rank).to(eq("4"))
    end

    it("creates a card with a specified suit") do
      expect(card.suit).to(eq("S"))
    end

    it 'creates cards with ranks and suits as strings' do
      card = Card.new(2, "D")
      expect(card.suit).to(be_a(String))
    end

  end

  context('#description') do
    it("returns a string describing the card") do
      test_card = Card.new("Q", "S")
      expect(test_card.description).to(eq("Queen of Spades"))
    end
  end

  context('.from_str') do
    it("creates a card from a string in the format 'rank-suit'") do
      test_card = Card.from_str("K-S")
      expect(test_card).to(eq(Card.new("K", "S")))
      test_card = Card.from_str("10-H")
      expect(test_card).to(eq(Card.new("10", "H")))
    end
  end

  context('#==') do
    let(:card) {Card.new("3", "H")}

    it("is true if the other card has the same rank and suit") do
      expect(card == Card.new("3", "H")).to(eq(true))
    end

    it("is false if the other card has a different rank") do
      expect(card == Card.new("4", "H")).to(eq(false))
    end

    it("is false if the cards have different suits") do
      expect(card == Card.new("3", "S")).to(eq(false))
    end
  end

  context('#as_json') do
    let(:card) {Card.new("9", "H")}

    it("returns a json hash with the card's rank and suit") do
      expected_hash = {'rank' => '9', 'suit' => "H"}
      expect(card.as_json).to(eq(expected_hash))
    end
  end

  context('.from_json') do
    let(:card) {Card.new("J", "S")}

    it("creates a card using a json hash") do
      json_card = card.as_json
      expect(Card.from_json(json_card)).to(eq(card))
    end
  end
end
