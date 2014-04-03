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
# Copyright (c) 2014 Lisa Marie Maginnis
# Copyright (c) 2014 Nico Cesar


# Some fancy texts
high=`tput smso` highoff=`tput rmso`
ul=`tput smul` rul=`tput rmul`

. params.sh

function kill_screencasts {
    killall -9 sshd
}

function getinfo {
    interface=$(/sbin/ifconfig -a | egrep 'eth[0-9] ' | cut -f1 -d\ )
    ipaddress=$(/sbin/ifconfig $interface | sed -n 's/ *inet addr:\([0-9.]*\) .*/\1/p')
    clients=$(ps -ef | grep sshd:\ libreplanet@pts | grep -v grep | wc -l)
    screentarget=$(xauth list | tail -n 1 | sed 's/.*unix:\([0-9]*\) .*/localhost:\1/')


    
    if [ $clients -gt 0 ] && [ "$screentarget" != 'localhost:0.0' ] ; then
	client_status=CONNECTED
	endx='endx='$(DISPLAY=$screentarget xrandr | awk '/Screen 0/{sub(",", "", $10);x=$8; y=$10;} / connected/{sub(/x.*/, "", $3);secondhead=$3} END{print x-secondhead;}')

    else
	client_status=NOT\ CONNECTED
	screentarget=:0.0
	endx=''
    fi
    export screentarget endx
}

function view_camera {
    echo osd_show_text 'Press\ [ENTER]\ to\ quit' 100000 | \
	mplayer -lavdopts threads=2 -slave -fs -zoom rtsp://$IP &>/dev/null &
}

function start_stream {
    ./stream_2014.sh
}

while [[ "$reply" != "q" ]] && [[ "$reply" != "Q" ]]; do
    getinfo
    clear
    echo -n <<EOF "
 _     _ _                   ____  _                                      
| |   (_) |__  _ __ ___     / ___|| |_ _ __ ___  __ _ _ __ ___   ___ _ __ 
| |   | | '_ \| '__/ _ \____\___ \| __| '__/ _ \/ _\` | '_ \` _ \ / _ \ '__|
| |___| | |_) | | |  __/_____|__) | |_| | |  __/ (_| | | | | | |  __/ |   
|_____|_|_.__/|_|  \___|    |____/ \__|_|  \___|\__,_|_| |_| |_|\___|_|   

Streaming Point Info:
General:
 IP Address: "$high$ipaddress$highoff"

ScreenCast:
 Remote Client: "$high$client_status$highoff" Target: "$high$screentarget$highoff"

Main Menu:
 (S)tart Stream 
 (R)efresh Streaming Point Info
 (V)iew Camera Output
 (K)ill screencast clients

 (Q)uit

Selection: "
EOF


read reply

      case $reply in
      s|S)
      start_stream
      ;;
      k|K)
      kill_screencasts
      ;;
      r|R)
      ;;
      v|V)
      view_camera
      esac

done
