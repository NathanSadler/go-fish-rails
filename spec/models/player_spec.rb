require_relative '../../app/models/player'
require_relative '../../app/models/card'

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
end
