
#!/bin/bash  
su user0 -c 'zenity --info --text "Please close all running aplications...\n" --title "ATTENTION!"' 
path=`su user0 -c 'zenity --file-selection --directory --title="Choose a folder for session backup" --filename=/media/user0/'` 
cd /
rsync -a /home/user0/ $path/ --delete | su user0 -c 'notify-send "Saving session" "please wait ..."'
su user0 -c 'zenity --info --text "Session saved to '$path'" --title "Success!"' 
