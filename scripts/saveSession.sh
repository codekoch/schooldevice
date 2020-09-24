#!/bin/bash  
su user0 -c 'zenity --info --text "Please close all running aplications...\n" --title "ATTENTION!"' 
path=`su user0 -c 'zenity --file-selection --directory --title="Choose a folder for session backup" --filename=/media/user0/'` 
cd /
wget https://raw.githubusercontent.com/codekoch/schooldevice/master/scripts/rsync-homedir-local.txt -O rsync-homedir-local.txt
chmod 777 rsync-homedir-local.txt
rsync -a  --exclude-from=rsync-homedir-local.txt --progress /home/user0/ $path/ --delete | su user0 -c 'su user0 -c 'zenity --title "Session" --text "Saving...(Please wait for Ok Button)" --progress --auto-kill'
su user0 -c 'zenity --info --text "Session saved to '$path'" --title "Success!"' 
