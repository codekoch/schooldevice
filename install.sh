#!/bin/bash
version='version 1.12'

## Get some colors
function red_msg() {
echo -e "\\033[31;1m${@}\033[0m"
}
 
function green_msg() {
echo -e "\\033[32;1m${@}\033[0m"
}
function yellow_msg() {
echo -e "\\033[33;1m${@}\033[0m"
}
 
function blue_msg() {
echo -e "\\033[34;1m${@}\033[0m"
}

#### get latest version of current system
yellow_msg "Updating and upgrading the current system..."
sudo apt-get update
sudo apt-get -y upgrade

yellow_msg "Installing some software..."
#### install snap
sudo apt-get install -y snapd
sudo apt-get install -y rsync

yellow_msg "Installing vnc server and web connection capability..."
#### install screen mirroring via webbrowser
### install vnc-server
sudo apt-get install -y x11vnc

### install apache guacamole for web-vnc access
sudo add-apt-repository ppa:remmina-ppa-team/freerdp-daily -y
sudo apt-get update
sudo apt-get install -y freerdp2-dev freerdp2-x11
wget https://git.io/fxZq5 -O guac-install.sh
chmod +x guac-install.sh
sudo ./guac-install.sh --mysqlpwd ittaskteam --guacpwd schooldevice --nomfa --installmysql
# configure login settings
sudo echo 'auth-provider: net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider' >> /etc/guacamole/guacamole.properties
sudo echo 'basic-user-mapping: /etc/guacamole/user-mapping.xml' >> /etc/guacamole/guacamole.properties
sudo echo '<user-mapping>' > /etc/guacamole/user-mapping.xml
sudo echo ' ' >> /etc/guacamole/user-mapping.xml
sudo echo '    <authorize username="" password=""> ' >> /etc/guacamole/user-mapping.xml
sudo echo '        <protocol>vnc</protocol> ' >> /etc/guacamole/user-mapping.xml
sudo echo '        <param name="hostname">localhost</param> ' >> /etc/guacamole/user-mapping.xml
sudo echo '        <param name="port">5900</param>' >> /etc/guacamole/user-mapping.xml
sudo echo '    </authorize>' >> /etc/guacamole/user-mapping.xml
sudo echo '</user-mapping>' >> /etc/guacamole/user-mapping.xml
sudo systemctl restart tomcat9 guacd

### install some shellscripts and changes to connect easier
sudo cp scripts/showVNCAddress.sh /usr/bin/
sudo chmod 755 /usr/bin/showVNCAddress.sh
sudo sed -i 's/Exec=.$/Exec=\/usr\/bin\/sh -c "\/usr\/bin\/showVNCAddress.sh;\/usr\/bin\/x11vnc -gui tray=setpass -shared -rfbport PROMPT -bg -o %%HOME\/.x11vnc.log.%%VNCDISPLAY"/g' /usr/share/applications/x11vnc.desktop 
sudo cp scripts/connect2scholldevice.sh /usr/bin/
sudo chmod 755 /usr/bin/connect2schooldevice.sh
sudo cp scipts/x11vncConnect.desktop /usr/share/applications/
sudo chmod 755 /usr/share/applications/x11vncConnect.desktop

#### installation of timeshift (experimental)
#if [ "$1" == "reset" ]; then
#    yellow_msg "Reset...Press Enter when prompted and choose n for no GRUB re-install..."
#    snapshotname="`cat snapshotname.txt`" 
#    yellow_msg "Restore system with snapshot $snapshotname..."
#    sudo timeshift --restore --snapshot $snapshotname --yes
#    yellow_msg "Continue with new installation of schooldevice ..."
#else
#   if [ -f ./snapshotname.txt ]; then
#        snapshotname="`cat snapshotname.txt`"
#        yellow_msg "searching for old snapshot $snapshotname ..." 
#        test=`sudo timeshift --list | grep -i ">" | grep -i "$snapshotname" | awk '{print $3}'` 
#        if [ "$test" == "$snapshotname" ]; then
#           yellow_msg "found old snapshot $snapshotname. No need for new snapshot ..."
#        else
#          yellow_msg "adding timeshift ability ..." 
#          sudo apt-get install -y timeshift
#          yellow_msg "Creating snapshot of current system ...\n[this will take a while...time for a coffee!]"  
#          sudo timeshift --create --yes
#          sudo timeshift --list | grep -i ">" | awk '{print $3}' > ./snapshotname.txt
#        fi
#    else
#        yellow_msg "adding timeshift ability ..." 
#        sudo apt-get install -y timeshift
#        yellow_msg "Creating snapshot of current system ...[this will take a while...time for a coffee!]"  
#        sudo timeshift --create --yes
#        sudo timeshift --list | grep -i ">" | awk '{print $3}' > ./snapshotname.txt
#    fi  
#fi

#### add user user0
yellow_msg "adding user user0 with password user0..." 
sudo adduser user0 << EOF 
user0
user0
user0




Y
EOF
sudo passwd -d user0
#### set group rights
usermod -a -G adm,dialout,fax,cdrom,floppy,tape,dip,video,plugdev user0 

#### set selfhealing home of user user0
yellow_msg "setup selfhealing account for user0..."
sudo cp scripts/resethomedir.sh /etc/init.d/
sudo cp scripts/resethomedirstart.sh /etc/init.d/
chmod 755 /etc/init.d/resethomedir.sh
chmod 755 /etc/init.d/resethomedirstart.sh
sudo /etc/init.d/resethomedir.sh save

#### set autologin of user user0
yellow_msg "set autologin for user0"
sudo mkdir /etc/lightdm/lightdm.conf.d/
sudo echo '[Seat:*]' > /etc/lightdm/lightdm.conf.d/60-autologin.conf
sudo echo 'display-setup-script=/etc/init.d/resethomedirstart.sh' >> /etc/lightdm/lightdm.conf.d/60-autologin.conf
sudo echo 'display-stopped-script=/etc/init.d/resethomedirstart.sh' >> /etc/lightdm/lightdm.conf.d/60-autologin.conf
sudo echo 'autologin-user=user0' >> /etc/lightdm/lightdm.conf.d/60-autologin.conf
sudo echo 'autologin-user-timeout=0' >> /etc/lightdm/lightdm.conf.d/60-autologin.conf
sudo echo "# don't sleep the screen" >> /etc/lightdm/lightdm.conf.d/60-autologin.conf
sudo echo "xserver-command=X -s 0 dpms">> /etc/lightdm/lightdm.conf.d/60-autologin.conf
sudo chmod 755 /etc/lightdm/lightdm.conf.d/60-autologin.conf

#### Notify that you are in a selfhealing account
yellow_msg "adding autostart-script"
sudo mkdir /home/.saves/user0/.config/
sudo chown user0 /home/.saves/user0/.config/
sudo mkdir /home/.saves/user0/.config/autostart/
sudo chown user0 /home/.saves/user0/.config/autostart/
sudo echo '[Desktop Entry]' > /home/.saves/user0/.config/autostart/notify.desktop
sudo echo 'Type=Application' >> /home/.saves/user0/.config/autostart/notify.desktop
sudo echo 'Exec=/usr/bin/setbackground.sh' >> /home/.saves/user0/.config/autostart/notify.desktop
sudo echo 'Hidden=false' >> /home/.saves/user0/.config/autostart/notify.desktop
sudo echo 'NoDisplay=false' >> /home/.saves/user0/.config/autostart/notify.desktop
sudo echo 'Name=myscript' >> /home/.saves/user0/.config/autostart/notify.desktop
sudo echo 'Comment=Startup Script' >> /home/.saves/user0/.config/autostart/notify.desktop
sudo chown user0 /home/.saves/user0/.config/autostart/notify.desktop

#### set new user background
yellow_msg "set background for user0"
sudo cp schooldevice.png /usr/share/backgrounds/xfce/
sudo chmod 755 /usr/share/backgrounds/xfce/schooldevice.png
sudo echo '#!/bin/bash' > /usr/bin/setbackground.sh
sudo echo 'sleep 4' >> /usr/bin/setbackground.sh
sudo echo 'notify-send -t 10000 "ATTENTION:" "All local data will be lost during logout or restart!\nMake sure your data is backed up in the cloud or on an external device if necessary."' >> /usr/bin/setbackground.sh                                                
sudo echo 'notify-send -t 5000 "schooldevice" "'$version'"' >> /usr/bin/setbackground.sh
sudo echo 'xfconf-query --channel xfce4-desktop --list | grep last-image | while read path; do ' >> /usr/bin/setbackground.sh
sudo echo '    xfconf-query --channel xfce4-desktop --property $path --set /usr/share/backgrounds/xfce/schooldevice.png' >> /usr/bin/setbackground.sh
sudo echo ' done ' >> /usr/bin/setbackground.sh
sudo echo 'xfconf-query --channel xfce4-desktop --list | grep image-style | while read path; do ' /usr/bin/setbackground.sh
sudo echo '    xfconf-query --channel xfce4-desktop --property $path --set 1' >> /usr/bin/setbackground.sh
sudo echo ' done ' >> /usr/bin/setbackground.sh
sudo echo 'xset s off' >> /usr/bin/setbackground.sh
sudo echo 'xset s noblank' >> /usr/bin/setbackground.sh
sudo echo 'xset -dpms' >> /usr/bin/setbackground.sh
sudo chmod 755  /usr/bin/setbackground.sh

#### set save and load session ability
yellow_msg "set save and load session ability"
desktop_path=$(xdg-user-dir DESKTOP | grep -Eo '[^/]+/?$')  
sudo cp scripts/saveSession.sh /usr/bin/
sudo cp scripts/loadSession.sh /usr/bin/
sudo chown root /usr/bin/saveSession.sh
sudo chown root /usr/bin/loadSession.sh
sudo chmod 0755 /usr/bin/saveSession.sh
sudo chmod 0755 /usr/bin/loadSession.sh
sudo chgrp sudo /usr/bin/saveSession.sh
sudo chgrp sudo /usr/bin/loadSession.sh
sudo mkdir /home/.saves/user0/$desktop_path/
sudo chown user0 /home/.saves/user0/$desktop_path/
sudo cp scripts/loadSession.desktop /home/.saves/user0/$desktop_path/
sudo cp scripts/saveSession.desktop /home/.saves/user0/$desktop_path/
sudo cp scripts/loadSession.desktop /usr/share/applications/
sudo cp scripts/saveSession.desktop /usr/share/applications/
sudo chmod 755 /usr/share/applications/loadSession.desktop
sudo chmod 755 /usr/share/applications/saveSession.desktop
sudo chmod 755 /home/.saves/user0/$desktop_path/*.desktop
sudo chown user0 /home/.saves/user0/$desktop_path/*.desktop
sudo echo "# User privilege specification" > saveLoadSession
sudo echo "user0 ALL=(ALL:ALL) NOPASSWD:/usr/bin/saveSession.sh" >> saveLoadSession
sudo echo "user0 ALL=(ALL:ALL) NOPASSWD:/usr/bin/loadSession.sh" >> saveLoadSession
sudo cp ./saveLoadSession /etc/sudoers.d/saveLoadSession
sudo chmod 0440 /etc/sudoers.d/saveLoadSession

yellow_msg "Do you wish to install additional software (see: https://github.com/codekoch/schooldevice/blob/master/software.sh)?"
echo -n "(y/n)? "
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    sudo ./software.sh
    green_msg "Have fun!!"
    
else
    green_msg "Have fun!!"
    exit
fi
