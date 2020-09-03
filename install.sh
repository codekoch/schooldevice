#!/bin/bash
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

#### add user user
yellow_msg "adding user user0 with password user0..." 
sudo adduser user0 << EOF 
user0
user0
user0




Y
EOF

#### set selfhealing home of user user0
sudo cp scripts/resethomedir.sh /etc/init.d/
chmod 777 /etc/init.d/resethomedir.sh
sudo update-rc.d resethomedir.sh defaults
sudo /etc/init.d/resethomedir.sh save

yellow_msg "->DONE!"

