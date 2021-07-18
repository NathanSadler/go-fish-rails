module FillInForms
  def create_game(session, game_name = "Test Game", minimum_player_count = 2,
    maximum_player_count = nil)
    maximum_player_count.nil? ? (max_players = minimum_player_count) : (max_players = maximum_player_count)
    session.visit new_game_path
    session.fill_in 'Game Title', with: game_name
    session.fill_in 'Minimum Number of Players', with: minimum_player_count.to_s
    session.fill_in 'Maximum Number of Players', with: max_players
    session.click_on "Submit"
  end

  def login(session, email="foo@bar.com", password="foobar")
    session.visit login_path
    session.fill_in 'Email', with: email
    session.fill_in 'Password', with: password
    session.click_on "Submit"
  end

  def take_turn(session, player, card)
    session.choose(player)
    session.choose(card)
    session.click_on("Take Turn")
  end
end
