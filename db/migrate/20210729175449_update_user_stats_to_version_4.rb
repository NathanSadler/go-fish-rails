class UpdateUserStatsToVersion4 < ActiveRecord::Migration[6.1]
  def change
    update_view :user_stats, version: 4, revert_to_version: 3
  end
end
