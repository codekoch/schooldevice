
#!/bin/bash  
path=`zenity --file-selection --directory --title="Choose empty(!) folder for session backup" --filename=/media/user0/` 
cd /
rsync -a /home/user0/ $path/ --delete
notify-send "Session saved" "to $path"
 
sleep 60                                                
 
pkill notify-send                                          

