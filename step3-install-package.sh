USERNAME=admin
PACKAGES=~admin/Downloads

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
  yum localinstall *.rpm

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
# conda
################################################################################
# ./Anaconda3-5.2.0-Linux-x86_64.sh -b -p ~/.local/anaconda3
