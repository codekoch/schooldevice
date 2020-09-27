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

## Updating (experimental)
- Open a terminal
- su {user with admin rights}
- change to schooldevice git directory (see installing section)
> sudo ./install.sh reset 
- Press Enter and choose n for no Grub re-install 
- After restart all schooldevice installations are gone except of the schooldevice git directory
- Login, open a terminal and change again to schooldevice git directory
- get the latest version of schooldevie

> git pull

- repeat all steps of installing section after the "> cd schooldevice" command 

## Hints
- save and load your current user session:

  ![saveloadsession](https://github.com/codekoch/schooldevice/blob/master/saveLoadSession.png)
  
  the first save takes some time, but after that it is very fast thanks to rsync
  
  (use an external device with FAT32 filesystem and don't forget to eject before disconnecting)
- The selfhealing accounts username is user0 with password user0 
- login in as a user with admin rights and use 

    - > sudo /etc/init.d/resethomedir.sh save

        to save permanent changes 

    - > sudo /etc/init.d/resethomedir.sh dactivate

        to turn off selfhealing of user account user0

    - > sudo /etc/init.d/resethomedir.sh activate

        to turn on selfhealing of user account user0

- To build a takeaway-live-system (needs additional software pack):
    - >su {user with admin rights}
    - >sudo mount /dev/{yourdevice} /a
    - >/usr/bin/buildLinuxLive.sh
