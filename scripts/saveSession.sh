
#!/bin/bash  
cd /
sudo rm -R /tmp/user0
sudo mkdir /tmp/user0
sudo rsync -a /home/user0/ /tmp/user0/ --delete
sudo tar cfvz /tmp/user0{timestamp}.tar.gz /tmp/user0/
sudo chmod 777 /tmp/user0.tar.gz
