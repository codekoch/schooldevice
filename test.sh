  
#!/bin/bash
version='version 1.0'

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

### install snap
sudo apt-get install -y snapd

#### installation of timeshift (experimental)
if [ "$1" == "reset" ]; then
    yellow_msg "Reset...Press Enter when prompted and choose n for no GRUB re-install..."
    snapshotname="`cat snapshotname.txt`" 
    yellow_msg "Restore system with snapshot $snapshotname..."
    sudo timeshift --restore --snapshot $snapshotname --yes
    yellow_msg "Continue with new installation of schooldevice ..."
else
   if [ -f ./snapshotname.txt ]; then
        snapshotname="`cat snapshotname.txt`"
        yellow_msg "searching for old snapshot $snapshotname ..." 
        test=`sudo timeshift --list | grep -i ">" | grep -i "$snapshotname" | awk '{print $3}'` 
        if [ "$test" == "$snapshotname" ]; then
           yellow_msg "found old snapshot $snapshotname. No need for new snapshot ..."
        else
          yellow_msg "adding timeshift ability ..." 
          sudo apt-get install -y timeshift
          yellow_msg "Creating snapshot of current system ...\n[this will take a while...time for a coffee!]"  
          sudo timeshift --create --yes
          sudo timeshift --list | grep -i ">" | awk '{print $3}' > ./snapshotname.txt
        fi
    else
        yellow_msg "adding timeshift ability ..." 
        sudo apt-get install -y timeshift
        yellow_msg "Creating snapshot of current system ...[this will take a while...time for a coffee!]"  
        sudo timeshift --create --yes
        sudo timeshift --list | grep -i ">" | awk '{print $3}' > ./snapshotname.txt
    fi  
fi
################!/bin/sh

# Als root ausführen
if [ `id -u` -ne 0 ];then exec sudo $0; fi

# Einlesen der Release-Daten
. /etc/lsb-release

# User "keinpasswort" anlegen
adduser --gecos ',,,' --disabled-password keinpasswort

# User "keinpasswort" mit den Standardgruppenzugehörigkeiten ausstatten
usermod -a -G adm,dialout,fax,cdrom,floppy,tape,dip,video,plugdev,fuse keinpasswort

# Passwort auf einen leer-String setzen
usermod -p U6aMy0wojraho keinpasswort

# Erlaubnis das Passwort erst nach 10000 Tagen ändern zu dürfen
passwd -n 100000 keinpasswort


# Hilfsfunktion, um Sicherungskopien zu erstellen
backup () {
  test -s $1 && cp $1 $1-`date +%Y%m%d-%H%M%S`-`stat -c '%G-%U-%a' $1`
}

# Namen in der Anmeldeliste verstecken (nobody muss dann zusätzlich
# angegeben werden).
# Statt der Datein custom.conf können diese Einträge auch in 
# der Datei gdm.schemas eingefügt werden. Oder man gibt den 
# zu versteckenden Benutzern eine uid unter 1000.
backup /etc/gdm/custom.conf
cat <<EOFA >/etc/gdm/custom.conf
[greeter]

Exclude=nobody,ladmin,$SUDO_USER
EOFA


# Ab 10.10 gibt es eine Sicherheitseinstellung, welche 
# die einwandfreien Ausführung von aufs verhindert. Ausschalten!
if [ $DISTRIB_RELEASE = "10.10" ];then
  backup /etc/sysctl.d/60-hardlink-restrictions-disabled
  cat <<-EOFB >/etc/sysctl.d/60-hardlink-restrictions-disabled
	# aufs läuft nur ohne "Hardlink restrictions". Siehe
	# https://wiki.kubuntu.org/Security/Features/Historical
	kernel.yama.protected_nonaccess_hardlinks=0
EOFB
fi

# Verzeichnis für die Veränderungen erstellen
install -d -o keinpasswort -g keinpasswort /home/.keinpasswort_rw

# aufs-Schicht über das home-Verzeichnis legen
backup /etc/fstab
echo "none /home/keinpasswort aufs br:/home/.keinpasswort_rw:/home/keinpasswort 0 0" >> /etc/fstab

# Aufruf des cleanup-script nach dem Login bzw. Logout
for i in PostSession PostLogin; do
  backup /etc/gdm/$i/Default
cat <<-EOFC >/etc/gdm/$i/Default
	#!/bin/sh

	test "\$USER" = "keinpasswort" && /usr/local/bin/cleanup-keinpasswort.sh \$0
EOFC
  # oben erzeugte Script die richtigen Rechte zuweisen
  chmod 755 /etc/gdm/$i/Default
done


# Aufruf des cleanup-script nach dem Booten, damit 
# keine untergeschobenen Dateien überdauern.
backup /etc/rc.local
cat <<-EOFD >/etc/rc.local
	#!/bin/sh

	/usr/local/bin/cleanup-keinpasswort.sh \$0
EOFD


# cleanup-script erzeugen, welches ...
#   1. .keinpasswort_rw reinigt und 
#   2. das virtuelles Windows unveränderbar macht.
backup /usr/local/bin/cleanup-keinpasswort.sh
cat <<-\$EOFE >/usr/local/bin/cleanup-keinpasswort.sh
	#!/bin/sh

	# cleanup-script soll nur weiterlaufen, wenn
	# keinpasswort durch aufs geschützt wird.
	immutable=`mount -l -t aufs |grep 'none on /home/keinpasswort type aufs (rw,br:/home/.keinpasswort_rw:/home/keinpasswort)'`
	test -n "$immutable" || exit 0;

	# Lösch-Funktion, welcher zusätzliche find-Argumente übergeben werden können
	loeschen (){
	  # Verwaltungs-Objekte von aufs
	  no_aufs="! -name .wh..wh.aufs ! -name .wh..wh.orph ! -name .wh..wh.plnk"
	  # Zusätliches find-Argument speichern
	  zusatz="$1"
	  # Wird dieses Script als root ausgeführt, kann das folgende "rm -rf" sehr gefährlich werden --
	  # insbesondere zu Testzwecken auf einem normalen Arbeitsrechner. Mit der folgenden Kombination
	  # ist sichergestellt, dass wirklich nur der Inhalt von .keinpasswort_rw gelöscht wird.
	  cd /home/.keinpasswort_rw && find . -maxdepth 1 -mindepth 1 $no_aufs $zusatz -print0|xargs -0 rm -rf
	}

	case "$1" in
	  /etc/gdm/PostLogin/Default)
	    # Inhalt von .keinpasswort_rw beim Login löschen. Das .pulse-Verzeichnis muss stehen
	    # bleiben, da es sonst bei direkter Neuanmeldung zu Sound-Problemen kommen kann.
	    loeschen "! -name .pulse"
	    # Unter winxp das device winxp-hda.vdi auf immutable setzen. Die Einträge 
	    # müssen an die lokale Situation angepasst sein.
	    sudo -u keinpasswort VBoxManage storageattach winxp --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium none
	    sudo -u keinpasswort VBoxManage modifyhd winxp-hda.vdi --type immutable
	    sudo -u keinpasswort VBoxManage storageattach winxp --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium winxp-hda.vdi
	    ;;
	  /etc/gdm/PostSession/Default)
	    # Inhalt von .keinpasswort_rw beim Logout verzögert löschen.
	    (sleep 3; loeschen "! -name .pulse") &
	    ;;
	  /etc/rc.local)
	    # Inhalt von .keinpasswort_rw beim Booten löschen, damit keine untergeschobenen
	    # Dateien einen Neustart überdauern. Sowohl das .pulse-Verzeichnis als auch
	    # Shell-Logins könnten sonst als Schwachstelle ausgenutzt werden.
	    loeschen
	    ;;
	  *)
	    # Nichts tun
	    ;;
	esac
	exit 0
$EOFE

# oben erzeugte Script die richtigen Rechte zuweisen
chmod 754 /usr/local/bin/cleanup-keinpasswort.sh

###### 




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
sudo echo 'notify-send "schooldevice" "'$version'"' >> /home/.saves/user0/setbackground.sh  
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
