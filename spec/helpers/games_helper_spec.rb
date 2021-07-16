require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the GamesHelper. For example:
#
# describe GamesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end

RSpec.describe GamesHelper, type: :helper do
  let(:session1) {Capybara::Session.new(:rack_test, Rails.application)}

  describe("turn_player_id") do
    let(:last_game) {Game.create}

    it("returns the user_id of the player whose turn it is") do
      loaded_go_fish = GoFish.load(last_game.id)
      loaded_go_fish.add_player(Player.new("Test Dummy", 14))
      loaded_go_fish.save
      expect(turn_player_id(last_game.id)).to(eq(14))
    end
  end
end
