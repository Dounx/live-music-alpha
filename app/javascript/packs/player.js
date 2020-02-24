import "aplayer/dist/APlayer.min.css";
import APlayer from "aplayer";

const songUrlPrefix = "https://music.163.com/song/media/outer/url?id=";

playlist.forEach(obj => {
    obj["url"] = songUrlPrefix + obj["id"]
});

const player = new APlayer({
    container: document.getElementById("player"),
    listMaxHeight: 1024,
    audio: playlist
});

export { player };