import { Controller } from "stimulus";
import consumer from "channels/consumer";

export default class extends Controller {
  static targets = ["status"]; // See data-target "game.status" in view template

  connect() {
    this.subscription = consumer.subscriptions.create(
      {
        // ActionCable channel Used
        channel: "GameChannel", 
        //See data-game-id=@game.id in the view template
        id: this.data.get("id"), 
      },
      {
        connected: this._connected.bind(this),
        disconnected: this._disconnected.bind(this),
        received: this._received.bind(this)
      }
    );
  }

  _connected() {
    console.log("_connected")
  }

  _disconnected() {
    console.log("_disconnected")
  }

    //Updates target when data is received on the channel
  _received(data) {
    console.log("This is getting called...")
    const element = this.statusTarget
    element.innerHTML = data
  }
}