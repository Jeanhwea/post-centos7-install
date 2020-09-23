HERE=`cd $(dirname $0); pwd`

################################################################################
# backup repo files
################################################################################
cd /etc/yum.repos.d && ls *.repo | xargs -I {} mv {} {}.bak


################################################################################
# setup local iso package repository
################################################################################
mkdir -p /media/cdrom && mount /dev/cdrom /media/cdrom &&
  cp $HERE/snippet/CentOS-Media.repo /etc/yum.repos.d/CentOS-Media.repo


################################################################################
# install packages
################################################################################
yum makecache

# common tools
yum install -y net-tools tmux ntp kernel-devel kernel-doc kernel-headers

# for oracle 11g install
yum install -y binutils compat-libcap1 compat-libstdc++-33 gcc gcc-c++ glibc \
    glibc-devel ksh libgcc libstdc++ libstdc++-devel libaio libaio-devel libXi \
    libXtst make sysstat unixODBC unixODBC-devel oracleasm-support

yum install -y cmake automake zip unzip python3 python3-devel python-devel python \
    rpm-build redhat-rpm-config asciidoc hmaccalc perl-ExtUtils-Embed pesign xmlto \
    audit-libs-devel binutils-devel elfutils-devel elfutils-libelf-devel ncurses-devel \
    newt-devel numactl-devel pciutils-devel python-devel zlib-devel readline-devel

# for cuda install
# yum install -y python* python3* mesa* freeglut* *glew*
