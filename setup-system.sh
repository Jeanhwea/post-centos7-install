PACKAGE=~admin/Download

# close firewall
systemctl disable firewalld

################################################################################
# docker
################################################################################
cd /tmp && tar xzvf $PACKAGE/docker-ce-19.03.7.tar.gz

cd docker-ce-19.03.7 && yum localinstall *.rpm

cp $PACKAGE/docker-compose /usr/local/bin/docker-compose && \
chmod +x /usr/local/bin/docker-compose

systemctl enable docker.service
sudo usermod -G docker admin
