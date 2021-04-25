HERE=`cd $(dirname $0); pwd`
USERNAME=admin
ISODIR=~admin/download/iso

################################################################################
# setup local iso package repository
################################################################################
mkdir -p /media/cdrom
if [ -f $ISODIR/CentOS-7-x86_64-Everything-1908.iso ]; then
  mount -o loop $ISODIR/CentOS-7-x86_64-Everything-1908.iso /media/cdrom
else
  mount /dev/cdrom /media/cdrom
fi

if [ ! -f /media/cdrom/repodata/repomd.xml ]; then
  echo "Error: mount centos iso first!"
  exit 2
fi
cd /etc/yum.repos.d && ls *.repo | xargs -I {} mv {} {}.bak
cp $HERE/snippet/CentOS-Media.repo /etc/yum.repos.d/CentOS-Media.repo


################################################################################
# install packages
################################################################################
yum makecache

# common tools
yum install -y net-tools vim tmux ntp tree kernel-devel kernel-doc kernel-headers

# for oracle 11g install
yum install -y binutils compat-libcap1 compat-libstdc++-33 gcc gcc-c++ glibc \
    glibc-devel ksh libgcc libstdc++ libstdc++-devel libaio libaio-devel libXi \
    libXtst make sysstat unixODBC unixODBC-devel oracleasm-support

yum install -y gcc gcc-c++ cmake automake zip unzip python3 python3-devel \
    python-devel python rpm-build redhat-rpm-config asciidoc hmaccalc \
    perl-ExtUtils-Embed pesign xmlto audit-libs-devel binutils-devel \
    elfutils-devel elfutils-libelf-devel ncurses-devel bison-devel newt-devel \
    numactl-devel pciutils-devel python-devel zlib-devel readline-devel

# for mysql
yum install -y cmake ncurses ncurses-devel bison bison-devel openssl openssl-devel

# for cuda install
# yum install -y python* python3* mesa* freeglut* *glew*
