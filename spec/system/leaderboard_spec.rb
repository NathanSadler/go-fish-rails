require 'rails_helper'

RSpec.describe "Leaderboard", type: :system do
  let(:session) {Capybara::Session.new(:rack_test, Rails.application)}

  before(:each) do
    ["lalala", "sasasa", "teeteetee"].each {|name| User.create(name: name, email: "#{name}@gmail.com", password: name, password_confirmation: name)}
    3.times {Game.create([])}
    Game.all.each do |game|
      User.each {|user| GameUser.create(game_id: game.id, user_id: user.id)}
    end
  end

  describe("ordering users by games won") do
    it("lists users by number of games won in descending order") do
      GameUser.where(user_id: User.all[1].id).each {|gameuser| gameuser.update(is_game_winner: true)}
      go_to_leaderboard(session)
      binding.pry
    end
  end
end