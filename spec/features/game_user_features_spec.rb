require 'rails_helper'


RSpec.describe "GameUsers", type: :system do
  fixtures :users
  let(:test_user) {users(:michael)}

  context("joining a game") do
    before(:each) do
      visit login_path
      fill_in 'session_email', with: test_user.email
      fill_in 'session_password', with: "password"
      click_on "Submit"
    end

    it("creates an entry in the GameUsers table") do
      Game.create(title: "Join Game Test", minimum_player_count: 2)
      visit "/games/#{Game.last.id}"
      click_on "Join Game"
      last_gameuser = GameUser.last
      expect(User.find_by(id: last_gameuser.user_id).email).to(eq(test_user.email))
      expect(Game.find_by(id: last_gameuser.game_id).title).to(eq("Join Game Test"))
    end
  end
end
