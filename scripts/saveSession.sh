
#!/bin/bash  
path=`su user0 -c 'zenity --file-selection --directory --title="Choose empty(!) folder for session backup" --filename=/media/user0/'` 
cd /
rsync -a /home/user0/ $path/ --delete | su user0 -c 'notify-send "Saving session" "please wait ..."'
su user0 -c 'notify-send "Session saved" "to '$path'"'
 
sleep 60
 
pkill notify-send


