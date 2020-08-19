mkdir -p /media/cdrom && mount /dev/cdrom /media/cdrom && \
  rm /etc/yum.repos.d/* && cp CentOS-Media.repo /etc/yum.repos.d/CentOS-Media.repo

yum makecache && \
  yum install -y net-tools tmux ntp kernel-devel kernel-doc kernel-headers \
      python* python3* mesa* freeglut* *glew*

yum install -y binutils compat-libcap1 compat-libstdc++-33 gcc gcc-c++ glibc \
    glibc-devel ksh libgcc libstdc++ libstdc++-devel libaio libaio-devel libXi \
    libXtst make sysstat unixODBC unixODBC-devel oracleasm-support

yum install -y cmake git zip unzip tmux python3 python3-devel python-devel python \
    rpm-build redhat-rpm-config asciidoc hmaccalc perl-ExtUtils-Embed pesign xmlto \
    audit-libs-devel binutils-devel elfutils-devel elfutils-libelf-devel ncurses-devel \
    newt-devel numactl-devel pciutils-devel python-devel zlib-devel readline-devel
