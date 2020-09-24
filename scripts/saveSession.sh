#!/bin/bash  
su user0 -c 'zenity --info --text "Please close all running aplications...\n" --title "ATTENTION!"' 
path=`su user0 -c 'zenity --file-selection --directory --title="Choose a folder for session backup" --filename=/media/user0/'` 
cd /
wget https://github.com/codekoch/schooldevice/blob/master/scripts/rsync-homedir-local.txt -O rsync-homedir-local.txt
chmod 777 rsync-homedir-local.txt
rsync -a  --exclude-from=rsync-homedir-local.txt --progress /home/user0/ $path/ --delete | su user0 -c 'notify-send "Saving session" "please wait ..."'
su user0 -c 'zenity --info --text "Session saved to '$path'" --title "Success!"' 
