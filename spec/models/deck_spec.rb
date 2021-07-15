require_relative '../../app/models/deck'

RSpec.describe 'Deck' do
  let(:test_deck) {Deck.new}

  context('.initialize') do
    it("creates a deck of 52 cards") do
      expect(test_deck.cards.length).to(eq(52))
    end

    it("has cards_dealt set to false on creation") do
      expect(test_deck.cards_dealt?).to(eq(false))
    end
  end

  context('#default_deck') do
    it("Returns an unshuffled array of all 52 standard cards") do
      default_deck = Deck.default_deck
      expect(default_deck.length).to(eq(52))
      default_deck.each {|item| expect(item.is_a?(Card)).to eq true}
    end
  end

  context('#shuffle') do
    before(:each) do
      test_deck.shuffle
    end

    let(:unmatched_card) {false}
    let(:second_deck) {Deck.new}

    it("shuffles itself") do
      test_deck_suits = test_deck.cards.map(&:suit)
      test_deck_ranks = test_deck.cards.map(&:rank)
      expect(test_deck_suits == second_deck.cards.map(&:suit)).to(eq(false))
      expect(test_deck_ranks == second_deck.cards.map(&:rank)).to(eq(false))
    end
  end

  context('#set_cards') do
    it("sets the cards in the deck") do
      new_cards = [Card.new("A", "S"), Card.new("A", "C")]
      test_deck.send(:set_cards, new_cards)
      expect(test_deck.cards).to(eq(new_cards))
    end
  end

  context('#cards_in_deck') do
    it("returns the number of cards in the deck") do
      test_deck.draw_card
      expect(test_deck.cards_in_deck).to(eq(51))
    end
  end

  context('#draw_card') do
    it("removes a card from the top of the deck and returns it") do
      passed_cards = [Card.new("4", "H"), Card.new("7", "C")]
      rigged_deck = Deck.new(passed_cards)
      drawn_card = rigged_deck.draw_card
      expect(drawn_card.suit != rigged_deck.cards[0].suit).to(eq(true))
      expect(drawn_card.rank != rigged_deck.cards[0].rank).to(eq(true))
    end
  end

  context('#as_json') do
    let(:test_deck) {Deck.new([Card.new("2", "S"), Card.new("3", "S")])}

    it("returns a json hash containing an array with each card in the deck") do
      expected_hash = {"cards" => [{"rank" => "2", "suit" => "S"},
        {"rank" => "3", "suit" => "S"}]}
      expect(test_deck.as_json).to(eq(expected_hash))
    end
  end

  context('.from_json') do
    let(:test_deck) {Deck.new([Card.new("2", "S"), Card.new("3", "S")])}

    it("returns a deck of cards using data from a json hash") do
      json_deck = test_deck.as_json
      expect(Deck.from_json(json_deck).cards).to(eq(test_deck.cards))
      
    end
  end

end
