#!/bin/bash
version='version 1.15'

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
sudo rm -R /var/lib/tomcat9/webapps/ROOT/index.html
sudo echo '<% response.sendRedirect("/guacamole"); %>' > /var/lib/tomcat9/webapps/ROOT/index.jsp
sudo chmod 755 /var/lib/tomcat9/webapps/ROOT/index.jsp
sudo systemctl restart tomcat9 guacd

### install some shellscripts and changes to connect easier
sudo cp scripts/showVNCAddress.sh /usr/bin/
sudo chmod 755 /usr/bin/showVNCAddress.sh
new='\/usr\/bin\/sh -c "\/usr\/bin\/showVNCAddress.sh;\/usr\/bin\/x11vnc -gui tray=setpass -shared -rfbport 5900 -bg -o %%HOME\/.x11vnc.log.%%VNCDISPLAY"'
sudo sed -i "s/Exec=.*/Exec=$new/g" /usr/share/applications/x11vnc.desktop 
sudo cp scripts/connect2schooldevice.sh /usr/bin/
sudo chmod 755 /usr/bin/connect2schooldevice.sh
sudo cp scripts/x11vncConnect.desktop /usr/share/applications/
sudo chmod 755 /usr/share/applications/x11vncConnect.desktop



#### set new user background
yellow_msg "set background for user0"
sudo cp schooldevice.png /usr/share/xfce4/backdrops/
sudo chmod 755 /usr/share/xfce4/backdrops/schooldevice.png
sudo echo '#!/bin/bash' > /usr/bin/setbackground.sh
sudo echo 'sleep 4' >> /usr/bin/setbackground.sh
sudo echo 'notify-send -t 10000 "ATTENTION:" "All local data will be lost during logout or restart!\nMake sure your data is backed up in the cloud or on an external device if necessary."' >> /usr/bin/setbackground.sh                                                
sudo echo 'notify-send -t 5000 "schooldevice" "'$version'"' >> /usr/bin/setbackground.sh
sudo echo 'xfconf-query --channel xfce4-desktop --list | grep last-image | while read path; do ' >> /usr/bin/setbackground.sh
sudo echo '    xfconf-query --channel xfce4-desktop --property $path --set /usr/share/xfce4/backdrops/schooldevice.png' >> /usr/bin/setbackground.sh
sudo echo ' done ' >> /usr/bin/setbackground.sh
sudo echo 'xfconf-query --channel xfce4-desktop --list | grep image-style | while read path; do ' >> /usr/bin/setbackground.sh
sudo echo '    xfconf-query --channel xfce4-desktop --property $path --set 1' >> /usr/bin/setbackground.sh
sudo echo ' done ' >> /usr/bin/setbackground.sh
sudo echo 'xset s off' >> /usr/bin/setbackground.sh
sudo echo 'xset s noblank' >> /usr/bin/setbackground.sh
sudo echo 'xset -dpms' >> /usr/bin/setbackground.sh
sudo chmod 755  /usr/bin/setbackground.sh


    green_msg "Have fun!!"

