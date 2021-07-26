module NavigatePages
  def join_game(session, game_id)
    session.visit("/games/#{game_id}")
    join_game_from_info_page(session)
  end

  def join_game_from_info_page(session)
    session.click_on("Join Game")
  end

  def start_game(session)
    session.click_on("Try To Start Game")
  end

  def view_game_list(session)
    session.visit("/games")
  end

  def view_home_page(session)
    session.visit("/")
  end
end