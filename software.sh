#!/bin/bash

### via snap 
sudo apt-get install -y default-jdk

sudo apt-get install default-jre 

sudo snap install netbeans --classic

sudo apt-get install -y openjdk-8-jre openjdk-8-jdk openjdk-8-jre-headless openjdk-8-jdk-headless

sudo snap install intellij-idea-community --classic

sudo snap install --classic eclipse 

sudo snap install blender --classic

sudo snap install bluej

sudo snap install arduino

sudo snap install openboard

### via apt-get 
sudo apt-get install -y cura

sudo apt-get install -y ballerburg

sudo apt-get install -y qrencode

sudo apt-get install -y flatpak

sudo apt-get install -y geogebra

sudo apt-get install -y gimp

sudo apt-get install -y youtube-dl

sudo apt-get install -y simplescreenrecorder

sudo apt-get install -y ballerburg

sudo apt-get install -y python-pip

sudo apt-get install -y nodejs

sudo apt-get install -y feh

sudo apt-get install -y gparted

sudo apt-get install -y net-tools

sudo apt-get install -y vlc

#### Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb

#### Greenfoot
wget http://www.greenfoot.org/download/files/Greenfoot-linux-361.deb
sudo apt install -y ./Greenfoot-linux-361.deb

#### unetbootin
sudo add-apt-repository ppa:gezakovacs/ppa -y
sudo apt-get update
sudo apt-get install -y unetbootin

#### Veyon
sudo add-apt-repository ppa:veyon/stable -y
sudo apt-get update
sudo apt-get install -y veyon

#### Linux Live Kit
sudo apt-get install -y squashfs-tools
sudo apt-get install -y genisoimage 
sudo apt-get install -y zip 
sudo apt-get install -y aufs-dkms 
sudo apt-get install -y dkms
git clone https://github.com/Tomas-M/linux-live
sudo mkdir /a
sudo  sed -i 's/VMLINUZ=\/vmlinuz/VMLINUZ=\/boot\/vmlinuz/g' linux-live/config
sudo  sed -i 's|LIVEKITDATA=/tmp|LIVEKITDATA=/a|g' linux-live/config
sudo cp -R linux-live /opt/
sudo chmod -R 755 /opt/linux-live
sudo echo '#!/bin/bash' > /usr/bin/buildLinuxLive.sh
sudo echo 'cd /opt/linux-live' >> /usr/bin/buildLinuxLive.sh
sudo echo './build' >> /usr/bin/buildLinuxLive.sh
sudo chmod 755 /usr/bin/buildLinuxLive.sh

#### Openboard
#sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
#sudo flatpak install -y flathub ch.openboard.OpenBoard
#sudo cp openboard.png /usr/share/pixmaps/
#echo '[Desktop Entry]' > /usr/share/applications/openboard.desktop
#echo 'Name=OpenBoard' >> /usr/share/applications/openboard.desktop
#echo 'Comment=OpenBoard' >> /usr/share/applications/openboard.desktop
#echo 'Type=Application' >> /usr/share/applications/openboard.desktop
#echo 'Encoding=UTF-8' >> /usr/share/applications/openboard.desktop
#echo 'Exec=/usr/bin/flatpak run ch.openboard.OpenBoard' >> /usr/share/applications/openboard.desktop
#echo 'Icon=/usr/share/pixmaps/openboard.png' >> /usr/share/applications/openboard.desktop
#echo 'Categories=GNOME;Application;Education;' >> /usr/share/applications/openboard.desktopecho 'Terminal=false' >> /usr/share/applications/openboard.desktop
#echo 'StartupNotify=true' >> /usr/share/applications/openboard.desktop
