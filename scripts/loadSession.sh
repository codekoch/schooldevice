
#!/bin/bash
su user0 -c 'zenity --info --text "Please close all running aplications..." --title "ATTENTION!"' 
path=`su user0 -c 'zenity --file-selection --directory --title="Choose folder with session backup" --filename=/media/user0/'` 
cd /
rsync -a --exclude=.cache --progress $path/ /home/user0/ --delete | su user0 -c 'notify-send "Loading session" "please wait ..."'
su user0 -c 'zenity --info --text "Session loaded from '$path'" --title "Success!"' 

