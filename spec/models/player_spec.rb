require_relative '../../app/models/player'

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
end
