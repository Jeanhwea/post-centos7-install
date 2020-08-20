HERE=`cd $(dirname $0); pwd`
cat tmpl_profile >> /etc/profile

################################################################################
# firewall
################################################################################
systemctl disable firewalld


################################################################################
# datetime
################################################################################
timedatectl set-timezone 'Asia/Shanghai'
timedatectl set-ntp yes

timedatectl
# ntpq -p


# timedatectl set-time "YYYY-MM-DD HH:MM:SS"
