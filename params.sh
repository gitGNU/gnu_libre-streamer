#!/bin/bash

# Gstreamer settings
BRIGHTNESS=0
CONTRAST=0.75
HUE=0
SATURATION=0.9
SERVER=18.4.89.36
PASSWORD=
BUFFERSIZE=100000
GST_DEBUG_DUMP_DOT_DIR=/tmp
WIDTH=480
HEIGHT=360
FPS=6
FPS1=1

# Insure we are all using the same xauthurity files
export XAUTHORITY=$HOME/.Xauthority

# Common options
CONFIG_FILE=config.xml

# Autodetect USB soundcard
SOUND="hw:"$(grep USB-Audio /proc/asound/cards|awk '{ print $1 }')",0"

# Configuration for specific streaming points
MOUNTPOINT="/example.ogv"
MOUNTPOINTAUDIO="/example.oga"
CONFIG_NET=net_config_example

# For multiple streaming points, uncomment and duplcaite the below if 
# statements. Also you should comment out the above configs.
# Sorry its so hackish :/

#if [ "$(hostname)" = "host.example.com" ]; then
#    MOUNTPOINT="/example.ogv"
#    MOUNTPOINTAUDIO="/example.oga"
#    CONFIG_NET=net_config_example
#fi
