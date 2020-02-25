import consumer from "./consumer"
import { player } from "../packs/player"

let room_id = document.getElementById("room-id").getAttribute("value");
let isAdmin = document.getElementById("is-admin").getAttribute("value");

consumer.subscriptions.create({ channel: "RoomsChannel", id: room_id }, {
  initialized() {
    this.sync = this.sync.bind(this);
  },

  connected() {
    this.perform("join");

    if (isAdmin) {
      setInterval(this.sync, 1000);
    }
  },

  disconnected() {
    this.perform("exit");
  },

  received(data) {
    if (isAdmin === true) {
      return;
    }

    switch (data["action"]) {
      case "sync":
        if (getCurrentId() !== data["id"]) {
          player.list.switch(data["id"]);
        }

        if (player.audio.paused !== data["paused"]) {
          if (data["paused"] === true) {
            player.pause();
          } else {
            player.play();
          }
        }

        let time = getCurrentTime();
        if (Math.abs(time - data["time"]) > 3) {
          player.seek(data["time"]);
        }

        break;
      case "notice":
        player.notice(data["msg"]);
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