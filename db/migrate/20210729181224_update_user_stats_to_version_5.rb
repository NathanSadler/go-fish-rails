class UpdateUserStatsToVersion5 < ActiveRecord::Migration[6.1]
  def change
    update_view :user_stats, version: 5, revert_to_version: 4
  end
end
