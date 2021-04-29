# 配置 ssh key 并上传文件
export RIP=192.168.0.159
ssh-copy-id admin@$RIP && scp -r download admin@$RIP:~

tar xzvf ~/download/packages/id_rsa_sr650.tar.gz

# samba 文件共享
sudo smbclient -L 192.168.0.201 -U Administrator
Enter SAMBA\Administrator's password:

        Sharename       Type      Comment
        ---------       ----      -------
        ADMIN$          Disk      远程管理
        C$              Disk      默认共享
        D$              Disk      默认共享
        IPC$            IPC       远程 IPC
        print$          Disk      打印机驱动程序
        开发服务器共享 Disk
Reconnecting with SMB1 for workgroup listing.
do_connect: Connection to 192.168.0.201 failed (Error NT_STATUS_RESOURCE_NAME_NOT_FOUND)
Failed to connect with SMB1 -- no workgroup available

sudo mkdir /mnt/share

sudo mount -t cifs -o username=Administrator,password='asdzxc1234!@#$',rw,nounix,iocharset=utf8,uid=1000,gid=1000 //192.168.0.201/开发服务器共享 /mnt/share

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
