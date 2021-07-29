class UpdateUserStatsToVersion2 < ActiveRecord::Migration[6.1]
  def change
    update_view :user_stats, version: 2, revert_to_version: 1
  end
end
