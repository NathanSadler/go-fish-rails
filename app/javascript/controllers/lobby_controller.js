import { Controller } from "stimulus";
import consumer from "channels/consumer";

export default class extends Controller {
  static targets = ["status"];

  connect() {
    this.subscription = consumer.subscriptions.create(
      {
        channel: "LobbyChannel",
        id: this.data.get("id"),
      },
      {
        connected: this._connected.bind(this),
        disconnected: this._disconnected.bind(this),
        received: this._received.bind(this),
      }
    );
  }

  _connected() {
    console.log("connected to LobbyChannel")
  }

  _disconnected() {
    console.log("disconnected from LobbyChannel")
  }

  _received(data) {
    // window.location.reload()
    // console.log("Tried and failed to reloaded Page")
    const element = this.statusTarget
    element.innerHTML = data
  }
}
