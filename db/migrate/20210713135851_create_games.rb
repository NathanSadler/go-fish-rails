class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.jsonb :go_fish
      t.datetime :finished_at
      t.datetime :created_at
      t.datetime :updated_at
      t.datetime :started_at
      t.integer :player_count
      t.bigint :winner_id

      # t.timestamps
    end
  end
end
