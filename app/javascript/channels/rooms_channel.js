import consumer from "./consumer"
import { player } from "../packs/player"

let room_id = document.getElementById("room-id").getAttribute("value");
let isAdmin = document.getElementById("is-admin").getAttribute("value");

consumer.subscriptions.create({ channel: "RoomsChannel", id: room_id }, {
  initialized() {
    this.sync = this.sync.bind(this);
  },

  connected() {
    if (isAdmin) {
      setInterval(this.sync, 1000);
    }
  },

  disconnected() {
  },

  received(data) {
    // FIXME
    // Don't know why can't directly use isAdmin
    if (isAdmin === true) {
      return;
    }

    switch (data["action"]) {
      case "sync":
        if (getCurrentId() !== data["id"]) {
          player.list.switch(data["id"]);
        }

        // FIXME
        if (player.audio.paused !== data["paused"]) {
          if (data["paused"] === true) {
            player.pause();
          } else {
            player.play();
          }
        }

        let time = getCurrentTime();
        if (Math.abs(time - data["time"]) > 1) {
          player.seek(data["time"]);
        }

        break;
      default:
        console.log(data);
    }
  },

  sync() {
    this.perform("sync", { paused: player.audio.paused, id: getCurrentId(), time: getCurrentTime() });
  }
});

function getCurrentId() {
  return player.list.index;
}

function getCurrentTime() {
  return player.audio.currentTime;
}