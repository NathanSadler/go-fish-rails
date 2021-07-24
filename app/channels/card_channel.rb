class CardChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "card_#{params[:id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
