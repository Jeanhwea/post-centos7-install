mkdir -p /media/cdrom && mount /dev/cdrom /media/cdrom && \
  rm /etc/yum.repos.d/* && cp CentOS-Media.repo /etc/yum.repos.d/CentOS-Media.repo

yum makecache && \
  yum install -y tmux ntp python* python3*

yum install -y binutils compat-libcap1 compat-libstdc++-33 gcc gcc-c++ glibc \
    glibc-devel ksh libgcc libstdc++ libstdc++-devel libaio libaio-devel libXi \
    libXtst make sysstat unixODBC unixODBC-devel oracleasm-support
