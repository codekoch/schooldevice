#!/usr/bin/bash
ipadress=`hostname -I | awk '{print $1}'`
notify-send -u critical "YOUR IP ADDRESS:" "$ipadress" 
