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
# Copyright (C) 2014 Nico Cesar

if [ $# -lt 1 ] 
then
    echo $#
    echo "usage: $0 elphel_camera_IP_address [config.xml] [/etc/autocampars.xml]"
fi

if [ "x$2" = "x" ]
then
    config_file=config.xml
else
    config_file=$2
fi

if [ "x$3" = "x" ]
then
    dest_file=/etc/autocampars.xml
else
    dest_file=$2
fi

echo -n "pinging $1 ... "
ping -c2 $1 > /dev/null
RESULT=$?

if [ $RESULT -ne 0 ]
then
    echo cant ping $1
    exit 1
fi
echo OK

#do an url encode of the file
python -c 'import sys,urllib; print urllib.urlencode([("content",sys.stdin.read())])' < $config_file > /tmp/tmp_file 

#upload  to the camera
curl  -0  http://$1/admin-bin/editcgi.cgi?file= -d "save_file=/etc/autocampars.xml" -d "mode=0100644" -d "convert_crlf_to_lf=on" -d '@/tmp/tmp_file' | grep "Wrote"
RESULT=$?

if [ $RESULT -ne 0 ]
then
				echo problems loading the config
				exit 1
fi
exit 0
