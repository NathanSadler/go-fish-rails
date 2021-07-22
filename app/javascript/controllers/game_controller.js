import { Controller } from "stimulus";
import consumer from "channels/consumer";

export default class extends Controller {
  static targets = ["status"]; // See data-target "game.status" in view template

  connect() {
    console.log("hi there!")
    this.subscription = consumer.subscriptions.create(
      {
        channel: "GameChannel", // ActionCable channel Used
        id: this.data.get("id"), //See data-game-id=@game.id in the view template
      },
      {
        connected: this._connected.bind(this),
        disconnected: this._disconnected.bind(this),
        received: this._received.bind(this)
      }
    );
  }

  _connected() {
    console.log("yooooooo chaos got drip")
  }

  _disconnected() {
    console.log("where you going you big drip?")
  }

    //Updates target when data is received on the channel
  _received(data) {
    console.log("This is getting called...")
    const element = this.statusTarget
    element.innerHTML = data
  }
}