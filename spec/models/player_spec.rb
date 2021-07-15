require_relative '../../app/models/player'
require_relative '../../app/models/card'
require_relative '../../app/models/deck'

RSpec.describe Player do

  let(:player) {Player.new}

  context('.initialize') do
    it('creates a player with a specified name') do
      player = Player.new('John Doe')
      expect(player.name).to(eq('John Doe'))
    end

    it("defaults to the player name 'Player' if no name is specified") do
      expect(player.name).to(eq('Player'))
    end
  end

  context('#set_hand') do
    let(:card_list) {[Card.new("4", "H"), Card.new("7", "D")]}
    it("sets the hand of the player") do
      player.set_hand(card_list)
      expect(player.hand).to(eq(card_list))
    end

    it("does not just add cards to the players hand") do
      player.add_card_to_hand(Card.new("8", "S"))
      player.set_hand(card_list)
      expect(player.hand).to(eq(card_list))
    end
  end

  context('#add_card_to_hand') do
    it("adds a card to the player's hand") do
      test_card = Card.new("7", "H")
      player.add_card_to_hand(test_card)
      expect(player.hand).to(eq([test_card]))
    end

    it("can add multiple cards to the player's hand") do
      test_cards = [Card.new("9", "C"), Card.new("K", "S")]
      player.add_card_to_hand(test_cards)
      expect(player.hand).to(eq(test_cards))
    end

    it("does not just replace the player's hand") do
      player.add_card_to_hand(Card.new("9", "D"))
      test_card = Card.new("J", "C")
      player.add_card_to_hand(test_card)
      expect(player.hand).to(eq([Card.new( "9",  "D"), test_card]))
    end

    it("returns the cards that got added to the player's hand") do
      cards_to_add = [Card.new("3", "S"), Card.new("4", "S")]
      added_cards = player.add_card_to_hand(cards_to_add)
      expect(added_cards).to(eq(cards_to_add))
    end
  end

  context('#remove_card_from_hand') do
    before(:each) do
      player.add_card_to_hand([Card.new("2", "D"), Card.new("3", "D"), Card.new("4", "D")])
    end

    it("removes specified cards from the player's hand") do
      player.remove_card_from_hand(Card.new("2", "D"))
      expect(player.hand).to(eq([Card.new("3", "D"), Card.new("4", "D")]))
    end

    it("returns the cards that it removed") do
      test_cards = Card.new("2", "D")
      expect(player.remove_card_from_hand(test_cards)).to(eq(test_cards))
    end

    it("returns nil if the player doesn't have the specified cards") do
      test_card = Card.new("2", "H")
      expect(player.remove_card_from_hand(test_card)).to(eq(nil))
    end
  end

  context('#remove_cards_with_rank') do
    it('returns and removes all cards with a specified rank') do
      cards = [Card.new( "8",  "S"), Card.new( "8", "D"),
        Card.new( "4",  "H")]
      player.add_card_to_hand(cards)
      removed_cards = player.remove_cards_with_rank("8")
      expect(player.hand).to(eq([Card.new( "4",  "H")]))
      expect(removed_cards).to(eq([Card.new( "8",  "S"), Card.new( "8", "D")]))
    end

    it('returns an empty array if the player does not have cards of the '+
    'specified ranks') do
      cards = [Card.new("7", "H"), Card.new("9", "S")]
      removed_cards = player.remove_cards_with_rank("2")
      expect(removed_cards).to(eq([]))
    end
  end

  context('#draw_card') do
    let(:test_deck) {test_deck = Deck.new([Card.new("8", "H"), Card.new("8", "C")])}
    it("takes the top card from the deck and adds it to their hand") do
      player.draw_card(test_deck)
      expect(player.has_card?(Card.new("8", "H"))).to(eq(true))
      expect(test_deck.cards).to(eq([Card.new("8", "C")]))
    end

    it("returns the card the player took") do
      taken_card = player.draw_card(test_deck)
      expect(taken_card).to(eq(Card.new("8", "H")))
    end
  end

  context('#has_card?') do
    let(:card_list) {[Card.new("4", "H"), Card.new("7", "D")]}
    before(:each) do
      player.set_hand(card_list)
    end

    it("is true if the player has the specified card") do
      expect(player.has_card?(Card.new("4", "H"))).to(eq(true))
    end

    it("is false if the player doesn't have the specified card") do
      expect(player.has_card?(Card.new("Q", "D"))).to(eq(false))
    end
  end

  context('#find_book_ranks') do
    before(:each) do
      book = ["S", "D", "H", "C"].map {|suit| Card.new( "7",  suit)}
      book_b = ["S", "D", "H", "C"].map {|suit| Card.new( "9",  suit)}
      player.add_card_to_hand(book)
      player.add_card_to_hand(book_b)
    end

    it("returns an array the ranks of each book") do
      expect(player.find_book_ranks).to(eq(["7", "9"]))
    end
  end


end
