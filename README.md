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

> su

> ./install.sh
- Restart to autologin into the new account
> sudo shutdown -r now
- Choose default panel when asked for
- Customize everything according to your needs
- Open a terminal, save the current account settings and restart system
> su

> sudo /etc/init.d/resethomedir.sh save

> sudo shutdown -r now
- Have fun with your new schooldevice 
