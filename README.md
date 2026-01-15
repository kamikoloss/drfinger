# DRFINGER

## 動画の準備方法

動画をダウンロードする

- https://github.com/yt-dlp/yt-dlp/wiki/Installation
- `yt-dlp https://www.youtube.com/watch?v=Uk9-jvuVBPY -o input`

動画を ogv に変換する

- https://www.ffmpeg.org/download.html
- https://docs.godotengine.org/ja/4.x/tutorials/animation/playing_videos.html
- `ffmpeg -i input.webm -vf "scale=-1:720" -q:v 6 -q:a 6 -g:v 64 output.ogv`
