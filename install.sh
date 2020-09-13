#!/bin/bash
version='schooldevice 1.0'
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

#### installation of timeshift
if [ $1 = "update" ]; then
  yellow_msg "Updating...Press Enter when prompted"
  git fetch --all
  git reset --hard origin/master
  git pull
  snapshotname="`cat snapshotname.txt`" 
  yellow_msg "Restore system with snapshot $snapshotname..."
  sudo timeshift --restore --snapshot $snapshotname --yes
  yellow_msg "Continue with new installation of schooldevice ..."
  exit
else
   if [ -f ./snapshotname.txt ]; then
        sudo timeshift --delete-all --yes
        $snapshotname = `cat snapshotname.txt`
        sudo timeshift --delete --snapshot $snapshotname
   else
        yellow_msg "adding timeshift ability ..." 
        sudo apt-get install -y timeshift
    fi  
   yellow_msg "Creating snapshot of current system ...[this will take a while...time for a coffee!]"  
   sudo timeshift --create --yes
   sudo timeshift --list | grep -i ">" | awk '{print $3}' > ./snapshotname.txt
fi

#### add user user
yellow_msg "adding user user0 with password user0..." 
sudo adduser user0 << EOF 
user0
user0
user0




Y
EOF

#### set group rights
usermod -a -G adm,dialout,fax,cdrom,floppy,tape,dip,video,plugdev user0 

#### set selfhealing home of user user0
yellow_msg "setup selfhealing account for user0..."
sudo cp scripts/resethomedir.sh /etc/init.d/
chmod 777 /etc/init.d/resethomedir.sh
sudo update-rc.d resethomedir.sh defaults
sudo /etc/init.d/resethomedir.sh save
sudo  sed -i 's/Required-Stop:     $local_fs $remote_fs dbus/Required-Stop:     $local_fs $remote_fs dbus resethomedir.sh/g' /etc/init.d/lightdm

#### set autologin of user user0
yellow_msg "set autologin for user0"
sudo mkdir /etc/lightdm/lightdm.conf.d/
sudo echo '[Seat:*]' > /etc/lightdm/lightdm.conf.d/60-autologin.conf
sudo echo 'autologin-user=user0' >> /etc/lightdm/lightdm.conf.d/60-autologin.conf
sudo echo 'autologin-user-timeout=0' >> /etc/lightdm/lightdm.conf.d/60-autologin.conf
sudo echo "# don't sleep the screen" >> /etc/lightdm/lightdm.conf.d/60-autologin.conf
sudo echo "xserver-command=X -s 0 dpms">> /etc/lightdm/lightdm.conf.d/60-autologin.conf

#### Notify that you are in a selfhealing account
yellow_msg "adding notfify-script"
sudo mkdir /home/.saves/user0/.config/
sudo mkdir /home/.saves/user0/.config/autostart/
sudo echo '[Desktop Entry]' > /home/.saves/user0/.config/autostart/notify.desktop
sudo echo 'Type=Application' >> /home/.saves/user0/.config/autostart/notify.desktop
sudo echo 'Exec=/home/user0/notify.sh' >> /home/.saves/user0/.config/autostart/notify.desktop
sudo echo 'Hidden=false' >> /home/.saves/user0/.config/autostart/notify.desktop
sudo echo 'NoDisplay=false' >> /home/.saves/user0/.config/autostart/notify.desktop
sudo echo 'Name=myscript' >> /home/.saves/user0/.config/autostart/notify.desktop
sudo echo 'Comment=Startup Script' >> /home/.saves/user0/.config/autostart/notify.desktop
sudo cp scripts/notify.sh /home/.saves/user0/
sudo chmod 755  /home/.saves/user0/notify.sh

#### set new user background
yellow_msg "set background for user0"
sudo cp schooldevice.png /usr/share/backgrounds/xfce/
sudo chmod 755 /usr/share/backgrounds/xfce/schooldevice.png
sudo echo '#!/bin/bash' > /home/.saves/user0/setbackground.sh
sudo echo 'xfconf-query --channel xfce4-desktop --list | grep last-image | while read path; do ' >> /home/.saves/user0/setbackground.sh
sudo echo '    xfconf-query --channel xfce4-desktop --property $path --set /usr/share/backgrounds/xfce/schooldevice.png' >> /home/.saves/user0/setbackground.sh
sudo echo ' done ' >> /home/.saves/user0/setbackground.sh
sudo echo 'xfconf-query --channel xfce4-desktop --list | grep image-style | while read path; do ' >> /home/.saves/user0/setbackground.sh
sudo echo '    xfconf-query --channel xfce4-desktop --property $path --set 1' >> /home/.saves/user0/setbackground.sh
sudo echo ' done ' >> /home/.saves/user0/setbackground.sh
sudo echo 'xset s off' >> /home/.saves/user0/setbackground.sh
sudo echo 'xset s noblank' >> /home/.saves/user0/setbackground.sh
sudo echo 'xset -dpms' >> /home/.saves/user0/setbackground.sh
sudo echo 'notify-send "You are working with '$version'"' >> /home/.saves/user0/setbackground.sh  
sudo echo 'sleep 60' >> /home/.saves/user0/setbackground.sh                                                
sudo echo 'pkill notify-send' >> /home/.saves/user0/setbackground.sh
sudo chmod 755  /home/.saves/user0/setbackground.sh
sudo echo '/home/user0/setbackground.sh &' >> /home/.saves/user0/notify.sh


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
