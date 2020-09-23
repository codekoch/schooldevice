
#!/bin/bash  
path=`zenity --file-selection --directory --title="Choose folder with session backup" --filename=/media/user0/` 
cd /
rsync -a $path/ /home/user0/ --delete
