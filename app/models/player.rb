class Player
  attr_reader :name, :hand

  def initialize(name = "Player")
    @name = name
    @hand = []
  end
end
