# nginx-rtmp-server

client
ffmpeg -re -i /home/gaian/Downloads/VolkswagenGTIReview.mp4 -vcodec libx264 -acodec aac -f flv rtmp://192.153.62.149:1935/live/test7

OBS studio
Key YouTube RTMP Configuration Details
Protocol: RTMPS (Secure RTMP).
Server URL: rtmps://a.rtmp.youtube.com/live2.
Port: 443.
Stream Key: Provided in YouTube Studio > Go Live.
Combined URL Format: rtmps://a.rtmp.youtube.com/live2/<stream-key>.
Video Codec: H.264.
Audio Codec: AAC. 
Google Help
Google Help
 +3
Steps to Configure
Access YouTube Studio: Go to studio.youtube.com and select Create > Go Live.
Get Credentials: Under "Stream Settings," find your Stream URL and Stream Key.
Configure Encoder (e.g., OBS, Camera):
Set the service to "Custom".
Paste rtmps://a.rtmp.youtube.com/live2 into the Server/URL field.
Paste your stream key into the designated stream key field.
Save & Stream: Save settings and start streaming from your encoder. 
Switcher Studio Help Center
Switcher Studio Help Center







listner:

http://192.153.62.149:8080/hls/test7.m3u8
