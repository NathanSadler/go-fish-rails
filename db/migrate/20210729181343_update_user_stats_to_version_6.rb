class UpdateUserStatsToVersion6 < ActiveRecord::Migration[6.1]
  def change
    update_view :user_stats, version: 6, revert_to_version: 5
  end
end
