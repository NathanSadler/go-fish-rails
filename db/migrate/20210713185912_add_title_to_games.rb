class AddTitleToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :title, :string
  end
end
