# 配置 ssh key 并上传文件
export RIP=192.168.0.159
ssh-copy-id admin@$RIP && scp -r download admin@${RIP}:~


# 修改主机名
hostnamectl set-hostname c114.localadmin

HOSTADDR=$(hostname -I | awk '{print $1}')
HOSTNAME=$(hostname)

echo "$HOSTADDR $HOSTNAME" >> /etc/hosts


# 时间和时区相关操作
timedatectl


# 创建和使用 anaconda 的虚拟环境
conda create --offline -n tf113
source activate tf113

pip download -i https://pypi.tuna.tsinghua.edu.cn/simple -d wheels_tf113 tensorflow-gpu==1.13.1
pip download -i https://pypi.tuna.tsinghua.edu.cn/simple -d wheels_tf200 tensorflow-gpu==2.0.0b1

pip install --no-index --find-link=wheels_tf113 tensorflow-gpu==1.13.1


# 图形界面操作
yum groupinstall "GNOME Desktop" "Graphical Administration Tools"
systemctl get-default
systemctl set-default graphical.target
systemctl set-default multi-user.target


################################################################################
# oracle
################################################################################
# mount cdrom
sudo mount /dev/cdrom /media/cdrom

/media/cdrom/database/runInstaller -silent -ignorePrereq -waitforcompletion -responseFile /tmp/db_install.rsp

# fix oracle install
sed -i 's/^\(\s*$(MK_EMAGENT_NMECTL)\)\s*$/\1 -lnnz11/g' $ORACLE_HOME/sysman/lib/ins_emagent.mk

# root scripts
/u01/app/oraInventory/orainstRoot.sh
/u01/app/oracle/product/11.2.0/dbhome_1/root.sh

# mkdir folders
mkdir /u01/app/oracle/oradata/mes
mkdir /u01/app/oracle/oradata/spot
