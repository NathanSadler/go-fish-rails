import { Controller } from "stimulus";
import consumer from "channels/consumer";

export default class extends Controller {
  static targets = ["status"];

  connect() {
    this.subscription = consumer.subscriptions.create(
      {
        channel: "CardChannel",
        id: this.data.get("id"),
        user: this.data.get("user")
      },
      {
        connected: this._connected.bind(this),
        disconnected: this._disconnected.bind(this),
        received: this._received.bind(this),
      }
    );
  }

  _connected() {
    console.log("connected!")
  }

  _disconnected() {
    console.log("disconnected!")
  }

  _received(data) {
    console.log("card controller _received!")
    // window.location.reload()
    const element = this.statusTarget
    element.innerHTML = data
  }
}