class AddIsGameWinnerToGameUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :game_users, :is_game_winner, :boolean
  end
end
