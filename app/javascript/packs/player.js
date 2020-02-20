import 'aplayer/dist/APlayer.min.css';
import APlayer from 'aplayer';

const ap = new APlayer({
    container: document.getElementById('player'),
    audio: [{
        name: '摄糖Therapy',
        artist: 'Kolaa',
        url: 'https://music.163.com/song/media/outer/url?id=1341046161.mp3',
        cover: 'http://p2.music.126.net/zzB1opAlPWJygp0_5lE2sg==/109951163806331927.jpg'
    }]
});