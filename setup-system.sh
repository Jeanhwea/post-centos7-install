PACKAGE=~admin/Downloads

cat profile >> /etc/profile

# close firewall
systemctl disable firewalld

################################################################################
# java
################################################################################
mkdir -p /usr/local/java && cd /usr/local/java
tar xzvf $PACKAGE/jdk-8u191-linux-x64.tar.gz
tar xzvf $PACKAGE/apache-maven-3.6.3-bin.tar.gz

################################################################################
# docker
################################################################################
cd /tmp && tar xzvf $PACKAGE/docker-ce-19.03.7.tar.gz

cd docker-ce-19.03.7 && yum localinstall *.rpm

cp $PACKAGE/docker-compose /usr/local/bin/docker-compose && \
chmod +x /usr/local/bin/docker-compose

systemctl enable docker.service
sudo usermod -G docker admin
