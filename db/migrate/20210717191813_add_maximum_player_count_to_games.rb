class AddMaximumPlayerCountToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :maximum_player_count, :int
  end
end
