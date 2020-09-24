
#!/bin/bash  
path=`su user0 -c zenity --file-selection --directory --title="Choose empty(!) folder for session backup" --filename=/media/user0/` 
cd /
rsync -a /home/user0/ $path/ --delete | notify-send "Saving session" "please wait ..."
notify-send "Session saved" "to $path"
 
sleep 60
 
pkill notify-send


