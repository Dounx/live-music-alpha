import "styles/player"

import consumer from "./consumer"
import APlayer from "aplayer";

let room_id = parseInt(document.getElementById("room-id").getAttribute("value"));
let isAdmin = (document.getElementById("is-admin").getAttribute("value") === "true");

const songApi = "https://music.163.com/song/media/outer/url?id=";

const host = window.location.hostname;
const port = "3000";
const api = "http://" + host + ":" + port;
const lrcApi = api + "/rooms/lrc?song_id=";

// Make song urls and lrcs
playlist.forEach(obj => {
  obj.url = songApi + obj.id;
  obj.lrc = lrcApi + obj.id;
});

const player = new APlayer({
  container: document.getElementById("player"),
  listFolded: true,
  listMaxHeight: 1024,
  audio: playlist,
  lrcType: 3,
  autoplay: true
});

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
    // Some code...
  },

  received(data) {
    switch (data["action"]) {
      case "sync":
        if (isAdmin) {
          break;
        }
        
        if (getCurrentIndex() !== data["index"]) {
          player.list.switch(data["index"]);
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
        flash("notice", data["msg"], 3000);
        break;
      default:
        console.log(data);
    }
  },

  sync() {
    this.perform("sync", { paused: player.audio.paused, index: getCurrentIndex(), time: getCurrentTime() });
  }
});

function getCurrentIndex() {
  return player.list.index;
}

function getCurrentId() {
  let index = getCurrentIndex();
  return player.list.audios[index]["id"]
}

function getCurrentTime() {
  return player.audio.currentTime;
}

function flash(level, msg, delay = 0) {
  let cls = "alert-info";
  switch (level) {
    case "notice":
      cls = "alert-info";
      break;
    case "error":
      cls = "alert-danger";
      break;
  }

  let ele = $(".flash").append("<div class=\"alert " + cls + " alert-dismissable fade show\">\n" +
      "      " + msg + "\n" +
      "      <button class=\"close\" data-dismiss=\"alert\">x</button>\n" +
      "    </div>");

  if (delay !== 0) {
    ele.delay(delay).fadeOut();
  }
}
