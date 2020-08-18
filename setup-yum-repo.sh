mkdir -p /media/cdrom && mount /dev/cdrom /media/cdrom

rm /etc/yum.repos.d/* && cp CentOS-Media.repo /etc/yum.repos.d/CentOS-Media.repo

yum makecache
