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

  def remove_card_from_hand(card)
    if self.hand.include?(card)
      set_hand(self.hand.reject {|hand_card| hand_card == card})
      return card
    else
      return nil
    end
  end


  def set_hand(new_hand)
    @hand = new_hand
  end

end
