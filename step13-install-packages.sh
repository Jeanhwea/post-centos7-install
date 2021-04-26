USERNAME=admin
PACKAGES=~admin/download/packages

CLRRED="\033[31m"
CLRGRN="\033[32m"
CLRYLW="\033[33m"
CLRBLU="\033[34m"
CLRMGA="\033[35m"
CLRRST="\033[0m"

logi() { echo -e "$(date +'%F %T : ') ${CLRGRN}$*${CLRRST}"; }
logw() { echo -e "$(date +'%F %T : ') ${CLRYLW}$*${CLRRST}"; }
loge() { echo -e "$(date +'%F %T : ') ${CLRRED}$*${CLRRST}"; }


if [ ! -d $PACKAGES ]; then
  loge "Error: $PACKAGES not found!"
  exit 2
fi


################################################################################
# bash completion
################################################################################
[ -f $PACKAGES/bash-completion-extras-2.1-11.el7.noarch.rpm ] && \
  yum install -y $PACKAGES/bash-completion-extras-2.1-11.el7.noarch.rpm


################################################################################
# java
################################################################################
mkdir -p /usr/local/java && \
  cd /usr/local/java && \
  tar xzvf $PACKAGES/jdk-8u191-linux-x64.tar.gz && \
  tar xzvf $PACKAGES/apache-maven-3.6.3-bin.tar.gz


################################################################################
# docker
################################################################################
cd /tmp && \
  tar xzvf $PACKAGES/docker-ce-19.03.7.tar.gz && \
  cd docker-ce-19.03.7 && \
  yum localinstall -y *.rpm

cp $PACKAGES/docker-compose /usr/local/bin/docker-compose && \
  chmod +x /usr/local/bin/docker-compose

systemctl enable docker.service
usermod -G docker $USERNAME


################################################################################
# rlwrap
################################################################################
cd /tmp && \
  tar xzvf $PACKAGES/rlwrap-0.43.tar.gz && \
  cd rlwrap-0.43 && \
  ./configure --prefix=/usr/local && \
  make && make install


################################################################################
# htop
################################################################################
cd /tmp && \
  tar xzvf $PACKAGES/htop-2.2.0.tar.gz && \
  cd htop-2.2.0 && \
  ./autogen.sh && \
  ./configure --prefix=/usr/local && \
  make && make install


################################################################################
# conda
################################################################################
# ./Anaconda3-5.2.0-Linux-x86_64.sh -b -p ~/.local/anaconda3
# echo 'export PATH=$HOME/.local/anaconda3/bin:$PATH' >> ~/.bashrc
