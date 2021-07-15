class AddMinimumPlayerCountToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :minimum_player_count, :int
  end
end
