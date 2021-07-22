# If a user is viewing a game with id of 1, then an ActionCable channel of scan_1 gets created
class GameChannel < ApplicationCable::GameChannel
  def subscribed
    # stream_from
  end
end