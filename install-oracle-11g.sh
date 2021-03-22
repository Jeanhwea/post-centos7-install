################################################################################
#  _____   _____   ______
# |  __ \ |  __ \ |  ____|
# | |__) || |__) || |__
# |  ___/ |  _  / |  __|
# | |     | | \ \ | |____
# |_|     |_|  \_\|______|
################################################################################
system-config-firewall-tui

################################################################################
# change system identifier
################################################################################
echo 'redhat-7' > /etc/redhat-release

################################################################################
# /etc/yum.repos.d/local-yum.repo
################################################################################
[local-media]
name=Local Media
baseurl=file:///media/cdrom/
gpgcheck=0
enabled=1


mkdir -p /media/cdrom && mount /dev/cdrom /media/cdrom

yum makecache
yum install -y binutils compat-libcap1 compat-libstdc++-33 gcc gcc-c++ glibc \
    glibc-devel ksh libgcc libstdc++ libstdc++-devel libaio libaio-devel make \
    sysstat unixODBC unixODBC-devel oracleasm-support

groupadd oinstall && \
  groupadd dba && \
  groupadd oper && \
  useradd -g oinstall -G dba,oper oracle

echo system | passwd --stdin oracle

mkdir -p /u01/app && \
  chown -R oracle:oinstall /u01/app && \
  chmod -R 775 /u01/app


################################################################################
# /etc/hosts
################################################################################
192.168.0.131 hostname hostname.localdomain


################################################################################
# /etc/sysconfig/network
################################################################################
NETWORKING=yes
HOSTNAME=hostname.localdomain


################################################################################
# /etc/profile
################################################################################
# 基础变量
export ORACLE_BASE=/u01/app/oracle
export ORACLE_SID=ora11g

export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/dbhome_1
export TNS_ADMIN=$ORACLE_HOME/network/admin
export PATH=$PATH:$ORACLE_HOME/bin

export EDITOR=vim
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib:/usr/local/lib
export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

# export NLS_LANG="AMERICAN.AL32UTF8"
export NLS_LANG=".AL32UTF8"
export NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS'

# 常用别名
alias cdob='cd $ORACLE_BASE'
alias cdoh='cd $ORACLE_HOME'
alias cdtns='cd $TNS_ADMIN'
alias cdod='cd $ORACLE_BASE/oradata'
alias envo='env | grep ORACLE'

# rlwrap must be install
alias sp='rlwrap sqlplus'
alias rman='rlwrap rman'

# quick commands
alias d0='dbshut $ORACLE_HOME'
alias d1='dbstart $ORACLE_HOME'
alias l0='lsnrctl stop'
alias l1='lsnrctl start'
alias e0='emctl stop dbconsole'
alias e1='emctl start dbconsole'
alias e8='emca -deconfig dbcontrol db -repos drop'
alias e9='emca -config dbcontrol db -repos create'

################################################################################
# /etc/sysctl.conf
################################################################################
# 共享内存 cat /proc/sys/kernel/shmall
# shmmni 缺省 4096 即可，shmmax 最小 536870912, 最大为物理内存减小 1 字节
# 32G 内存大约需要： 32*1024*1024*1024-1 = 34359738367
# 16G 内存大约需要： 16*1024*1024*1024-1 = 17179869183
#  8G 内存大约需要：  8*1024*1024*1024-1 = 8589934591
#  4G 内存大约需要：  4*1024*1024*1024-1 = 4294967295
# vim 里面在插入模式中使用 <C-r>= 简单计算
kernel.shmmax = 8589934591
kernel.shmmni = 4096
# Linux 的共享内存页大小为 4K，
# 对于 32G 内存的系统大约需要最大的页数为: 32*1024*1024/4 = 8388608
kernel.shmall = 2097152

# 进程之间通信消息大小的最大值
kernel.msgmax = 65536
# 信号量参数： semmsl semmns semopm semmni
kernel.sem = 250 32000 100 128

# 文件句柄数量限制
fs.aio-max-nr = 1048576
fs.file-max = 6815744

# 应用程序可用的 ipv4 端口范围
net.ipv4.ip_local_port_range = 9000 65500

# 套接字读写缓冲大小
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576


################################################################################
# /etc/security/limits.conf
################################################################################
oracle   soft   nproc    131072
oracle   hard   nproc    131072
oracle   soft   nofile   131072
oracle   hard   nofile   131072
oracle   soft   stack    10240
oracle   hard   stack    32768
oracle   soft   core     unlimited
oracle   hard   core     unlimited
oracle   soft   memlock  50000000
oracle   hard   memlock  50000000


################################################################################
# /etc/selinux/config
################################################################################
SELINUX=disabled

################################################################################
# /etc/fstab
################################################################################
tmpfs /dev/shm tmpfs defaults,size=8g 0 0

# dd if=/dev/zero of=/swapfile bs=1k count=4000000
# mkswap /swapfile
# swapon /swapfile
# swapon -s
# swapoff

################################################################################
# 标准大页和透明大页的配置
################################################################################


################################################################################
# 出现 agent nmhs 解决办法
################################################################################
# 主要因为C库的问题。解决办法就是手动指定C库位置。出现 agent nmhs 问题后找到
# $ORACLE_HOME/sysman/lib/ins_emagent.mk 文件里找到 $(MK_EMAGENT_NMECTL) 字符串，
# 然后在后面加上 -lnnz11 后点重试就可以解决
sed -i 's/^\(\s*$(MK_EMAGENT_NMECTL)\)\s*$/\1 -lnnz11/g' $ORACLE_HOME/sysman/lib/ins_emagent.mk


################################################################################
#  _____    ____    _____  _______
# |  __ \  / __ \  / ____||__   __|
# | |__) || |  | || (___     | |
# |  ___/ | |  | | \___ \    | |
# | |     | |__| | ____) |   | |
# |_|      \____/ |_____/    |_|
################################################################################

################################################################################
# root execute scripts
################################################################################

################################################################################
# /etc/oratab
################################################################################
ora11g:/u01/app/oracle/product/11.2.0/dbhome_1:Y


################################################################################
# /etc/rc.local
# chmod +x /etc/rc.local
################################################################################
# start oracle database
su - oracle -c 'lsnrctl start'
su - oracle -c 'dbstart /u01/app/oracle/product/11.2.0/dbhome_1'
# su - oracle -c 'emctl start dbconsole'

# fix em
emca -config dbcontrol db -repos recreate

# disable transparent hugepage
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
  echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi

if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
  echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi
