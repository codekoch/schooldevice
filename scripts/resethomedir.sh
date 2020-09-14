#!/bin/sh
### BEGIN INIT INFO
# Provides: Home-Dir-Resetter
# Required-Start: $syslog $remote_fs
# Required-Stop: $syslog $remote_fs
# Default-Start: 1 2
# Default-Stop:
# Description: Reset home direction of a user while booting written by Armin Jacob & Anton Bracke
# License: This script is licensed under GNU GPL.
### END INIT INFO
 
### BEGIN INIT TODO ADJUST
USER=user0
TMPDIR=/home/.saves/
### END INIT TODO ADJUST
 
case "$1" in
     start)
         if [ -d $TMPDIR/$USER ]
         then
                sudo rm -r -f /home/$USER
                sudo cp -a -r -f $TMPDIR/$USER /home/
                sudo chown -R $USER:users /home/$USER
                sudo rm -r -f /tmp/*
                echo "The homedir of $USER is now resetted!"
         else 
                echo "The Backup-Directory doesn't exists!"
         fi
         ;;
     save)
         if [ -d $TMPDIR/$USER ]
         then
                sudo rm -r $TMPDIR/$USER
         fi
                sudo mkdir -p $TMPDIR/$USER
                sudo cp -r -f /home/$USER /home/.saves
                wait
         if [ -d $TMPDIR/$USER ]
         then
                echo "The home-dir of $USER was successfully saved to: $TMPDIR/$USER"
         else
                echo "Unfortunately, the backup operation was unsuccessful. Please repeat the command!"
         fi
         ;;
      *)
         echo "Usage: $0 {start|save}"
         exit 1
         ;;
esac
exit 0
