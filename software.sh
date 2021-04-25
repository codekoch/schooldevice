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


### via apt-get 
sudo apt-get install -y cura

sudo apt-get install -y ballerburg

sudo apt-get install -y qrencode

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

sudo apt-get install -y xournal

sudo apt-get install -y stellarium 

#### Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb

#### Openboard
wget https://github.com/OpenBoard-org/OpenBoard/releases/download/v1.6.0a1/openboard_ubuntu_20.04_1.6.0-a.1_amd64.deb
sudo apt install -y ./openboard_ubuntu_20.04_1.6.0-a.1_amd64.deb

#### Greenfoot
wget http://www.greenfoot.org/download/files/Greenfoot-linux-361.deb
sudo apt install -y ./Greenfoot-linux-361.deb

#### unetbootin
sudo add-apt-repository ppa:gezakovacs/ppa -y
sudo apt-get update
sudo apt-get install -y unetbootin

#### Veyon
#sudo add-apt-repository ppa:veyon/stable -y
#sudo apt-get update
#sudo apt-get install -y veyon

### Virtual Box
sudo apt-get install -y virtualbox
sudo apt-get install -y virtualbox—ext–pack

### apache guacamole
sudo add-apt-repository ppa:remmina-ppa-team/freerdp-daily
sudo apt-get update
sudo apt-get install -y freerdp2-dev freerdp2-x11
wget https://git.io/fxZq5 -O guac-install.sh
chmod +x guac-install.sh
sudo ./guac-install.sh --mysqlpwd ittaskteam --guacpwd schooldevice --nomfa --installmysql
sudo echo 'auth-provider: net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider' >> /etc/guacamole/guacamole.properties
sudo echo 'basic-user-mapping: /etc/guacamole/user-mapping.xml' >> /etc/guacamole/guacamole.properties
sudo echo '<user-mapping>' > /etc/guacamole/user-mapping.xml
sudo echo ' ' >> /etc/guacamole/user-mapping.xml
sudo echo '    <authorize username="USERNAME" password="PASSWORD"> ' >> /etc/guacamole/user-mapping.xml
sudo echo '        <protocol>vnc</protocol> ' >> /etc/guacamole/user-mapping.xml
sudo echo '        <param name="hostname">localhost</param> ' >> /etc/guacamole/user-mapping.xml
sudo echo '        <param name="port">5901</param>' >> /etc/guacamole/user-mapping.xml
sudo echo '        <param name="password">VNCPASS</param>' >> /etc/guacamole/user-mapping.xml
sudo echo '    </authorize>' >> /etc/guacamole/user-mapping.xml
sudo echo '</user-mapping>' >> /etc/guacamole/user-mapping.xml
sudo apt-get install -y tightvncserver
# Configure VNC password
umask 0077                                        # use safe default permissions
mkdir -p "$HOME/.vnc"                             # create config directory
chmod go-rwx "$HOME/.vnc"                         # enforce safe permissions
vncpasswd -f <<<"VNCPASS" >"$HOME/.vnc/passwd"  # generate and write a password
sudo systemctl restart tomcat9 guacd



#### Linux Live Kit
#sudo apt-get install -y squashfs-tools
#sudo apt-get install -y genisoimage 
#sudo apt-get install -y zip 
#sudo apt-get install -y aufs-dkms 
#sudo apt-get install -y dkms
#git clone https://github.com/Tomas-M/linux-live
#sudo mkdir /a
#sudo  sed -i 's/VMLINUZ=\/vmlinuz/VMLINUZ=\/boot\/vmlinuz/g' linux-live/config
#sudo  sed -i 's|LIVEKITDATA=/tmp|LIVEKITDATA=/a|g' linux-live/config
#sudo cp -R linux-live /opt/
#sudo chmod -R 755 /opt/linux-live
#sudo echo '#!/bin/bash' > /usr/bin/buildLinuxLive.sh
#sudo echo 'cd /opt/linux-live' >> /usr/bin/buildLinuxLive.sh
#sudo echo './build' >> /usr/bin/buildLinuxLive.sh
#sudo chmod 755 /usr/bin/buildLinuxLive.sh

