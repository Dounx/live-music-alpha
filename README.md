## Live Music

Web 版网易云音乐同步听歌。

使用歌单链接创建房间，把 URL 分享给朋友即可。

创建房间的用户会将其听歌状态同步给当前房间内的其他用户。

### 依赖

* Ruby 2.7.0
* Node.js
* Yarn
* Redis
* PostgreSQL

### 开发环境

```bash
# Session 1
rvm install 2.7.0
bundle install
rails db:create
rails db:migrate
rails s

# Session 2
./bin/webpack-dev-server

# Session 3
./bin/netease-cloud-music-api
```

### 部署

[live-music-docker](https://github.com/Dounx/live-music-docker)

### To Do List

* Dockerfile
* 房间列表
* 歌词列表
* 聊天窗口
* 自定义歌单
* 性能优化
* 模块化（不仅仅是网易云音乐）