class CreateUserStats < ActiveRecord::Migration[6.1]
  def change
    create_view :user_stats
  end
end
