USERNAME = "username"
USERGROUP = "usergroup"

#sudoer
sudo su

#installing deps
apt-get install python-software-properties
add-apt-repository ppa:swift-core/release
apt-get update
apt-get install curl gcc git-core memcached python-configobj python-coverage python-dev python-nose python-setuptools python-simplejson python-xattr sqlite3 xfsprogs python-webob python-eventlet python-greenlet python-pastedeploy python-netifaces

#using a loopback device for storage
mkdir /srv
dd if=/dev/zero of=/srv/swift-disk bs=1024 count=0 seek=1000000
mkfs.xfs -i size=1024 /srv/swift-disk
#cat "/srv/swift-disk /mnt/sdb1 xfs loop,noatime,nodiratime,nobarrier,logbufs=8 0 0" > /etc/fstab
mkdir /mnt/sdb1
mount /mnt/sdb1
mkdir /mnt/sdb1/1 /mnt/sdb1/2 /mnt/sdb1/3 /mnt/sdb1/4
chown ${USERNAME}:${USERGROUP} /mnt/sdb1/*
for x in {1..4}; do ln -s /mnt/sdb1/$x /srv/$x; done
mkdir -p /etc/swift/object-server /etc/swift/container-server /etc/swift/account-server /srv/1/node/sdb1 /srv/2/node/sdb2 /srv/3/node/sdb3 /srv/4/node/sdb4 /var/run/swift
chown -R ${USERNAME}:${USERGROUP} /etc/swift /srv/[1-4]/ /var/run/swift
#mkdir /var/run/swift
#chown <your-user-name>:<your-group-name> /var/run/swift
#add to /etc/rc.local

#setting up rsync
mv ${FILES}/rsyncd.conf /etc/rsyncd.conf
#edit /etc/default/rsync
#RSYNC_ENABLE=true
service rsync restart

#getting the code
mkdir ~/bin
git clone https://github.com/openstack/swift.git
cd ~/swift; sudo python setup.py develop
cat "export PATH=${PATH}:~/bin" > ~/.bashrc
. ~/.bashrc



