class CreateGameUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :game_users do |t|
      t.bigint :game_id
      t.bigint :user_id
      t.datetime :created_at
      t.datetime :updated_at

      #t.timestamps
    end
  end
end
