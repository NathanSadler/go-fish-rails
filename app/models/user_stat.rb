class UserStat < ApplicationRecord
  belongs_to: user

  def readonly?
    true
  end
end
