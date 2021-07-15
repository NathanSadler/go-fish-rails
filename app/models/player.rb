class Player
  attr_reader :name, :hand

  def initialize(name = "Player")
    @name = name
    @hand = []
  end

  def add_card_to_hand(card)
    if(card.is_a?(Array))
      set_hand(hand.concat(card))
      card
    else
      set_hand(hand.push(card))
      [card]
    end
  end

  def draw_card(deck)
    taken_card = deck.draw_card
    add_card_to_hand(taken_card)
    taken_card
  end

  def find_book_ranks
    occurences = {}
    hand.each do |card|
      occurences[card.rank] ? occurences[card.rank] += 1 : occurences[card.rank] = 1
    end
    occurences.keys.select {|rank| occurences[rank] == 4}
  end

  def has_card?(card)
    hand.include?(card)
  end

  def remove_card_from_hand(card)
    if self.hand.include?(card)
      set_hand(self.hand.reject {|hand_card| hand_card == card})
      return card
    else
      return nil
    end
  end

  def remove_cards_with_rank(rank)
    cards_to_remove = hand.select {|card| card.rank == rank}
    set_hand(hand - cards_to_remove)
    cards_to_remove
  end

  def set_hand(new_hand)
    @hand = new_hand
  end

end
