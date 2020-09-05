# schooldevice
Shellscript to modify a linuxdistribution for use in school with one single offline account for multiple users.

The single offline account acts like a selfhealing account with a reset of all data after restart
## Getting Started
- Install a new linux system based on a debian distrubution (testet with <a href=https://xubuntu.org/>Xubuntu 20.4 LTS 64bit</a>)
- (optional) make your own changes to the fresh installed system
## Installing
- Install git
> sudo apt-get install git
- Clone this repository
> git clone https://github.com/codekoch/schooldevice
- Start the install shellscript as root 
> cd schooldevice

> chmod -R 755 *

> sudo ./install.sh
- Restart to autologin into the new account user0
> sudo shutdown -r now
- Choose default panel when asked for
- Customize everything according to your needs
- Open a terminal, login as a user with admin rights, save the current account settings of user0 and restart system
> su {user with admin rights}

> sudo /etc/init.d/resethomedir.sh save

> sudo shutdown -r now
- Have fun with your new schooldevice 
## Hints
- The selfhealing accounts username is user0 with passwort user0 
- login in as a user with admin rights and use 

> sudo /etc/init.d/resethomedir.sh save

to save permanent changes   
