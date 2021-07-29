require 'rails_helper'

RSpec.describe "Leaderboard", type: :system do
  let(:session) {Capybara::Session.new(:rack_test, Rails.application)}

  before(:each) do
    User.first.destroy
    ["lalala", "sasasa", "teeteetee"].each {|name| User.create(name: name, email: "#{name}@gmail.com", password: name, password_confirmation: name)}
    3.times {Game.create()}
    Game.all.each do |game|
      User.all.each {|user| GameUser.create(game_id: game.id, user_id: user.id)}
    end
  end

  let(:test_user_a) {User.all[0]} # lalala
  let(:test_user_b) {User.all[1]} # sasasa
  let(:test_user_c) {User.all[2]} # teeteetee

  describe("ordering users") do
    it("lists users by number of games won in descending order") do
      GameUser.where(user_id: test_user_b.id).each {|gameuser| gameuser.update(is_game_winner: true)}
      go_to_leaderboard(session)
      user_names = session.all(:css, 'td:nth-child(2)')
      expect(user_names[0].text).to(eq(test_user_b.name))
    end

    # it("includes users that haven't won any games") do
    #   GameUser.where(user_id: test_user_b.id).each {|gameuser| gameuser.update(is_game_winner: true)}
    #   expect(session).to(have_content("sasasa"))
    #   expect(session).to(have_content("teeteetee"))
    # end

  end
end