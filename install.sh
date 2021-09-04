#!/usr/bin/bash
check_youtube_dl() {
      if command -v youtube-dl >/dev/null 2>&1;then
         echo "youtube-dl已安装"
      else 
         pip install youtube-dl
      fi
}

os_() {
   if command -v curl >/dev/null 2>&1;then
      echo "curl已安装"
   else 
      echo "curl未安装"
      $1 install curl -y
      echo "curl安装完成"
   fi
   if command -v ffmpeg >/dev/null 2>&1;then
      echo "ffmpeg已安装!"
   else
      echo "ffmpeg未安装"
      $1 install ffmpeg -y
      echo "ffmpeg安装完成!"
   fi
   if command -v pip >/dev/null 2>&1;then
      echo "pip已安装"
   else 
      echo "pip未安装"
      $1 install python -y
      echo "pip安装完成"
   fi
   check_youtube_dl
}

if command -v apt >/dev/null 2>&1;then 
   os_ apt
else :
   sudo rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
   sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
   os_ yum
fi