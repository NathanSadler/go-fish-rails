class UserStat < ApplicationRecord
  belongs_to :user

  def readonly?
    true
  end

  def formatted_duration
    in_game_time = game_time.parts
    "#{in_game_time[:hours].to_i}:#{in_game_time[:minutes].to_i}:#{in_game_time[:seconds].to_i}"
  end
end
