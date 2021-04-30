![schooldevice](https://github.com/codekoch/schooldevice/blob/master/schooldevice.jpg)
## schooldevice - free and reliable
This project should show that it is possible to get a working operating system for school use without the usual big commercial companies and account bindings. This should be a matter of course for the educational mission of every school and teacher.  

Schooldevice is a shellscript that modifies a linuxdistribution for use in school with one single offline account for multiple users.
The single offline account acts like a selfhealing account with a reset of all data after restart.

Nevertheless, the current session can be saved to and restored from an external data carrier at any time. Thus the account management is the responsibility of the users and not of the administrators.

## Getting Started
- Install a new linux system based on a debian distrubution (testet with <a href=https://xubuntu.org/>Xubuntu 20.4 LTS 64bit</a>)
- (optional) make your own changes to the fresh installed system
## Installing
- Open a terminal
- Install git
> sudo apt-get install git
- Clone this repository
> git clone https://github.com/codekoch/schooldevice
- Start the install shellscript as root 
> cd schooldevice

> sudo ./install.sh
- Decide if you want to install the additional software pack (see https://github.com/codekoch/schooldevice/blob/master/software.sh)
- Restart to autologin into the new account user0
> sudo shutdown -r now
- Customize everything according to your needs
- Open a terminal, login as a user with admin rights, save the current account settings of user0 and restart system
> su {user with admin rights}

> sudo /etc/init.d/resethomedir.sh save

> sudo shutdown -r now
- Have fun with your new schooldevice 

## Hints
### Save and load session (to an external device)
- save and load your current user session:

  ![saveloadsession](https://github.com/codekoch/schooldevice/blob/master/saveLoadSession.png)
  
  the first save takes some time, but after that it is very fast thanks to rsync
  
  (use an external device with FAT32 filesystem and don't forget to eject before disconnecting)

### Save changes permanently, activate, deactivate selfhealing
- login in as a user with admin rights (i.e. in a terminal during user0 session) and use 
    
    - > sudo /etc/init.d/resethomedir.sh save

        to save permanent changes 

    - > sudo /etc/init.d/resethomedir.sh dactivate

        to turn off selfhealing of user account user0

    - > sudo /etc/init.d/resethomedir.sh activate

        to turn on selfhealing of user account user0
        
### Screenmirroring / Remote Desktop Connection between schooldevices (and other devices)
![VNC](https://github.com/codekoch/schooldevice/blob/master/VNC.png)
- activate with <b>X11VNC Server</b>
- connect with <b>X11VNC Connect</b>
- (connect on every device in the same network via browseraddress http://\<ip-of-schooldevice\>:8080/guacamole)
- no login and no passwort required (changes can be done in /etc/guacamole/user-mapping.xml)

### Password for user0
- The selfhealing accounts username is user0 with password user0 

 
