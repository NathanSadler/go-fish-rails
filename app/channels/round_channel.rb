class RoundChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "round_#{params[:id]}_#{params[:user]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
