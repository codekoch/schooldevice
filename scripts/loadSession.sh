
#!/bin/bash  
path=`su user0 -c 'zenity --file-selection --directory --title="Choose folder with session backup" --filename=/media/user0/'` 
cd /
rsync -a $path/ /home/user0/ --delete | su user0 -c 'notify-send "Loading session" "please wait ..."'
su user0 -c 'notify-send "Session loaded" "from $path"'
 
sleep 60                                                
 
pkill notify-send    
