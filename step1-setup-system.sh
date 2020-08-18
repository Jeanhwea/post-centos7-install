cat profile >> /etc/profile

################################################################################
# firewall
################################################################################
systemctl disable firewalld

timedatectl set-timezone 'Asia/Shanghai'
timedatectl set-ntp yes
ntpq -p

# timedatectl set-time "YYYY-MM-DD HH:MM:SS"
