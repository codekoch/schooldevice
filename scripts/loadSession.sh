
#!/bin/bash  
sudo rm -R /tmp/user0
sudo mkdir /tmp/user0
sudo cp $1 /tmp/user0/
cd /tmp/user0/
sudo tar xfvz ./$1 
sudo rm /tmp/user0/$1
cd /
sudo rsync -a /tmp/user0/ /home/user0/  --delete
