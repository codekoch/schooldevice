#!/bin/bash
su user0 -c 'zenity --info --width 300 --text "Please close all running aplications...\nAnd insert an external device with FAT32 filesystem" --title "ATTENTION!"' 
path=`su user0 -c 'zenity --file-selection --directory --title="Choose folder with session backup" --filename=/media/user0/'` 
cd /
wget https://raw.githubusercontent.com/codekoch/schooldevice/master/scripts/rsync-homedir-local.txt -O rsync-homedir-local.txt
chmod 777 rsync-homedir-local.txt
rsync -a  --exclude-from=rsync-homedir-local.txt --progress $path/ /home/user0/ --delete | su user0 -c 'zenity --title "Session" --text "Loading from '$path'\nPlease wait for Ok Button..." --progress --pulsate --auto-kill'
