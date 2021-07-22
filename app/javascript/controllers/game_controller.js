import { Controller } from "@stimulus";
import consumer from "channels/consumer";

export default class extends Controller {
  static targets = ["status"]; // See data-target "game.status" in view template

  connect() {
    this.subscription = consumer.subscriptions.create(
      {
        channel: "ScanChannel", // ActionCable channel Used
        id: this.data.get("id"), //See data-game-id=@game.id in the view template
      },
      {
        connected: this._connected.bind(this),
        disconnected: this._disconnected.bind(this),
        received: this._received.bind(this)
      }
    );
  }

  _connected() {}

  _disconnected() {}

    //Updates target when data is received on the channel
  _received(data) {
    const element = this.statusTarget
    element.innerHTML = data
  }
}