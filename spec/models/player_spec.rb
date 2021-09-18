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

    it("doesn't add a card if it receives nil") do
      player.add_card_to_hand(nil)
      expect(player.hand).to(eq([]))
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

  context('#lay_down_books') do
    before(:each) do
      book = ["S", "D", "H", "C"].map {|suit| Card.new( "7",  suit)}
      book_b = ["S", "D", "H", "C"].map {|suit| Card.new( "9",  suit)}
      player.add_card_to_hand(book)
      player.add_card_to_hand(book_b)
      player.add_card_to_hand(Card.new("8", "S"))
    end

    it("removes every book from the player's hand") do
      player.lay_down_books
      expect(player.hand).to(eq([Card.new("8", "S")]))
    end

    it("increases the player's score by one for every book they have") do
      player.lay_down_books
      expect(player.score).to(eq(2))
    end
  end

  context('#increase_score') do
    it("increases the player's score by a specified amount") do
      player.increase_score(1)
      player.increase_score(3)
      expect(player.score).to(eq(4))
    end
  end

  context('#set_score') do
    it("sets the player's score") do
      player.send(:set_score, 7)
      expect(player.score).to(eq(7))
    end
  end

  context('#has_card_with_rank?') do
    before(:each) do
      player.add_card_to_hand(Card.new("7", "K"))
    end

    it("is true if the player has a card with the specified rank") do
      expect(player.has_card_with_rank?("7")).to(eq(true))
    end

    it("is false if the player doesn't have a card with the specified rank") do
      expect(player.has_card_with_rank?("8")).to(eq(false))
    end
  end

  context('#as_json') do
    let(:player) {Player.new("John Smith", 18)}
    let(:test_hand) {[Card.new("8", "S"), Card.new("Q", "D")]}

    before(:each) do
      player.set_hand(test_hand)
      player.send(:set_score, 4)
    end

    let(:json_result) {player.as_json}

    it("returns a hash that contains the player's name") do
      expect(json_result['name']).to(eq("John Smith"))
    end

    it("returns a hash that contains the player's score") do
      expect(json_result['score']).to(eq(4))
    end

    it("returns a hash that contains the player's hand") do
      expect(json_result['hand']).to(eq(test_hand.map(&:as_json)))
    end

    it("returns a hash that contains the player's user_id") do
      expect(json_result['user_id']).to(eq(18))
    end

    it("returns a hash with only 4 keys") do
      expect(json_result.keys.length).to(eq(4))
    end
  end

  context('.from_json') do
    let(:player) {Player.new("John Smith", 18)}
    let(:test_hand) {[Card.new("8", "S"), Card.new("Q", "D")]}

    before(:each) do
      player.set_hand(test_hand)
      player.send(:set_score, 8)
    end

    it("returns a deck of cards using data from a json hash") do
      json_player = player.as_json
      restored_player = Player.from_json(json_player)
      [:name, :hand, :score, :user_id].each do |attribute|
        expect(restored_player.send(attribute)).to(eq(player.send(attribute)))
      end
    end
  end

  context('#number_of_cards') do
    it("returns the number of cards in the player's hand") do
      player.set_hand([Card.new("7", "H"), Card.new("8", "H")])
      expect(player.number_of_cards).to(eq(2))
    end
  end

  context('.set_user_id') do
    it("changes the player's user_id") do
      expected_id = 420
      player.send(:set_user_id, expected_id)
      expect(player.user_id).to(eq(expected_id))
    end
  end

  context('#has_any_cards?') do
    it("is true if the player has at least one card in their hand") do
      player.set_hand([Card.new("A", "S")])
      expect(player.has_any_cards?).to(be(true))
    end

    it("is false if the player doesn't have any cards in their hand") do
      player.set_hand([])
      expect(player.has_any_cards?).to(be(false))
    end
  end

  fdescribe('#json_for_others') do
    before(:each) do 
      player.set_hand([Card.new("7", "H"), Card.new("8", "H")])
      player.send(:set_score, 4)
    end
    let(:json) {player.json_for_others()}

    it('has the name of the player') do
      expect(json['name']).to(eq('Player'))
    end

    it("has the number of cards in the player's hand") do
      expect(json['cards_in_hand']).to(eq(2))
    end

    it("has the player's score") do
      expect(json['score']).to(eq(4))
    end

    it("has the player's user_id") do
      expect(json['user_id']).to(eq(0))
    end
  end

end
