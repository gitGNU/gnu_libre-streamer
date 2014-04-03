#!/usr/bin/env bash
# This file is part of Libre-Streamer.
#
# Libre-Streamer is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Libre-Streamer is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Libre-Streamer.  If not, see <http://www.gnu.org/licenses/>.
#
# Copyright (C) 2014 Lisa Marie Maginnis
# Copyright (C) 2014 Nico Cesar

. ./params.sh 
 
export DISPLAY=$screentarget.0
export XAUTHORITY=$HOME/.Xauthority

# omghax (ugly)
if [ "$DISPLAY" = ":0.0.0" ]; then
    export DISPLAY=:0.0
fi

##echo loading configuration...
##./upload_config.sh $IP $CONFIG_FILE /etc/autocampars.xml
##RESULT=$?
##
##if [ $RESULT -ne 0 ] 
##then
##    exit 1
##fi 
##./upload_config.sh $IP $CONFIG_NET  /etc/conf.d/net.eth0

if [ $SOUND ]
then
gst-launch-0.10 -e rtspsrc location=rtsp://$IP:554 protocols=0x00000001 latency=100 !\
 rtpjpegdepay ! queue max-size-bytes=$BUFFERSIZE max-size-time=0 !\
 videorate force-fps=$FPS !\
 queue max-size-bytes=$BUFFERSIZE max-size-time=0 !\
 jpegdec max-errors=-1 idct-method=2 !\
 queue max-size-bytes=$BUFFERSIZE max-size-time=0 !\
 ffmpegcolorspace !\
 "video/x-raw-yuv, format=(fourcc)I420" !\
 queue max-size-bytes=$BUFFERSIZE max-size-time=0 !\
 videoscale !\
 "video/x-raw-yuv, width=$WIDTH, height=$HEIGHT" !\
 queue max-size-bytes=$BUFFERSIZE max-size-time=0 !\
 videomixer name=mix !\
 queue max-size-bytes=$BUFFERSIZE max-size-time=0 !\
 theoraenc bitrate=200 speed-level=1 !\
  queue max-size-bytes=$BUFFERSIZE max-size-time=0 !\
  oggmux name=mux alsasrc latency-time=100 device=$SOUND !\
  audioconvert ! audio/x-raw-float,channels=1 !\
  queue max-size-bytes=$BUFFERSIZE max-size-time=0 !\
  vorbisenc max-bitrate=60000 !\
  queue max-size-bytes=$BUFFERSIZE max-size-time=0 !\
  mux. mux. !\
  shout2send ip=$SERVER port=80 password=$PASSWORD mount=$MOUNTPOINT  ximagesrc  use-damage=false show-pointer=false remote=true display-name=$screentarget $endx !\
 queue max-size-bytes=$BUFFERSIZE max-size-time=0 !\
 ffmpegcolorspace !\
 queue max-size-bytes=$BUFFERSIZE max-size-time=0 !\
 videoscale !\
 "video/x-raw-yuv, width=$WIDTH, height=$HEIGHT" !\
 queue max-size-bytes=$BUFFERSIZE max-size-time=0 !\
 videobox border-alpha=0 fill=black left=-$WIDTH  !\
 videorate force-fps=$FPS1 !\
 mix.
fi
