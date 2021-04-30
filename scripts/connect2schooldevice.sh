#!/usr/bin/bash
ipaddress=$(zenity --width=400 --entry --title "IP ADDRESS of schooldevice to connecto to:" --text "Format: xxx.xxx.xxx.xxx")
google-chrome "http://$ipaddress:8080/guacamole"
