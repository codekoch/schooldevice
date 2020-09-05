#!/bin/bash
sudo apt-get update
sudo apt-get -y upgrade
# netbeans
sudo apt-get install -y netbeans
#blender
sudo apt-get install -y blender
# cura 
sudo apt-get install -y cura
# ballerburg
sudo apt-get install ballerburg

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

#### Openboard
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install -y flathub ch.openboard.OpenBoard
sudo cp openboard.png /usr/share/pixmaps/
sudo cp sources/home/mk/Desktop/* /usr/share/applications/
echo '[Desktop Entry]' > /usr/share/applications/openboard.desktop
echo 'Name=OpenBoard' >> /usr/share/applications/openboard.desktop
echo 'Comment=OpenBoard' >> /usr/share/applications/openboard.desktop
echo 'Type=Application' >> /usr/share/applications/openboard.desktop
echo 'Encoding=UTF-8' >> /usr/share/applications/openboard.desktop
echo 'Exec=/usr/bin/flatpak run ch.openboard.OpenBoard' >> /usr/share/applications/openboard.desktop
echo 'Icon=/usr/share/pixmaps/openboard.png' >> /usr/share/applications/openboard.desktop
echo 'Categories=GNOME;Application;Education;' >> /usr/share/applications/openboard.desktopecho 'Terminal=false' >> /usr/share/applications/openboard.desktop
echo 'StartupNotify=true' >> /usr/share/applications/openboard.desktop
