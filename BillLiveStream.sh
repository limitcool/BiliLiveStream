#!/bin/sh
# 读取配置文件
source conf
# 检测直播源
if [[ $1 =~ twitch ]]; then
   echo "twitch直播"
   twitch=$1
   M3U8=$(youtube-dl -g ${twitch} --no-check-certificate --proxy=${proxy}) ||  echo "Twitch直播未开始"
   echo $M3U8
   if [ -n "$M3U8" ]; then
      :
   else
      exit 0
   fi
elif [[ $1 =~ cloudfront ]]; then
   echo "mildom直播"
   M3U8=$1
elif [[ $1 =~ youtube ]]; then
   echo "youtube直播"
   M3U8=$1
else
   echo "其他直播"
   M3U8=$1
fi

# 调用接口进行开播
echo "开始直播"
start=$("curl --location --request POST 'https://api.live.bilibili.com/room/v1/Room/startLive' --header 'cookie: ${cookie}' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'room_id={$roomid}' --data-urlencode 'platform=pc' --data-urlencode 'area_v2=${area}'--data-urlencode 'csrf_token=${csrf_token}' --data-urlencode 'csrf=${csrf_token}'")
echo  "开播接口返回" $start >> /var/log/ffmpeg.log

while :; do               #loop循环，为了让模块一直运行
   sleep 5                # 每次检测时间5秒
   ffmpeg=$(pgrep ffmpeg) #检查ffmpeg是否在运行
   DATE=$(date +%y-%m-%d-%H:%M:%S)
   if [ -n "$ffmpeg" ]; then
      echo $DATE "ffmpeg正在运行" >>/var/log/ffmpeg.log
   #正确输入信息到日志文件
   else
      echo $DATE "ffmpeg没有在运行" >>/var/log/ffmpeg-error.log
      echo $DATE "开始运行ffmpeg" >>/var/log/ffmpeg.log
      ffmpeg -i $M3U8 -vcodec copy -acodec aac -f flv $BILL_RTMP_URL
   fi
done