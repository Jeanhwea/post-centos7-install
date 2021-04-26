HERE=`cd $(dirname $0); pwd`
USERNAME=admin
PACKAGES=~$USERNAME/download/packages
MYSQL_HOME=/usr/local/mysql

CLRRED="\033[31m"
CLRGRN="\033[32m"
CLRYLW="\033[33m"
CLRBLU="\033[34m"
CLRMGA="\033[35m"
CLRRST="\033[0m"

logi() { echo -e "$(date +'%F %T : ') ${CLRGRN}$*${CLRRST}"; }
logw() { echo -e "$(date +'%F %T : ') ${CLRYLW}$*${CLRRST}"; }
loge() { echo -e "$(date +'%F %T : ') ${CLRRED}$*${CLRRST}"; }


logi "Extract package to $MYSQL_HOME"
mkdir -p $MYSQL_HOME && \
  cd /tmp && \
  tar xzvf $PACKAGES/mysql-5.7.26.tar.gz && \
  tar xzvf $PACKAGES/mysql-boost-5.7.26.tar.gz && \
  mv /tmp/mysql-5.7.26 $MYSQL_HOME

groupadd mysql && \
  useradd -r -g mysql -s /bin/false mysql

mkdir -p $MYSQL_HOME/data && \
  chown -R mysql:mysql $MYSQL_HOME/data


logi "Build and install mysql"
cd $MYSQL_HOME/mysql-5.7.26 && \
  mkdir build && cd build && \
  cmake .. \
        -DCMAKE_INSTALL_PREFIX=$MYSQL_HOME \
        -DMYSQL_DATADIR=$MYSQL_HOME/data \
        -DMYSQL_UNIX_ADDR=$MYSQL_HOME/mysql.sock \
        -DSYSCONFDIR=/etc \
        -DEXTRA_CHARSETS=all \
        -DDEFAULT_CHARSET=utf8mb4 \
        -DDEFAULT_COLLATION=utf8mb4_general_ci \
        -DWITH_MYISAM_STORAGE_ENGINE=1 \
        -DWITH_INNOBASE_STORAGE_ENGINE=1 \
        -DWITH_MEMORY_STORAGE_ENGINE=1 \
        -DWITH_PARTITION_STORAGE_ENGINE=1 \
        -DDOWNLOAD_BOOST=0 \
        -DWITH_BOOST=$MYSQL_HOME/mysql-5.7.26/boost/boost_1_59_0 \
        -DENABLED_LOCAL_INFILE=1 \
        -DMYSQL_TCP_PORT=3306 \
        -DWITH_READLINE=1 \
        -DMYSQL_USER=mysql \
        -DWITH_SSL=yes && \
  make && make install


logi "Initialize mysql database"
if [ -f /etc/my.cnf ] && [ ! -f /etc/my.cnf.1 ]; then
  logw "Backup /etc/my.cnf"
  mv /etc/my.cnf /etc/my.cnf.1
fi

cat >> /etc/profile << EOF
[mysqld]
basedir   = $MYSQL_HOME
datadir   = $MYSQL_HOME/data
socket    = $MYSQL_HOME/mysql.sock
pid-file  = $MYSQL_HOME/mysqld.pid
log-error = $MYSQL_HOME/error.log

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links       = 0
user                 = mysql
bind-address         = 0.0.0.0
character-set-server = utf8mb4
collation-server     = utf8mb4_unicode_ci
init-connect         = 'SET NAMES utf8mb4'

# skip-grant-tables to reset root password
# skip-grant-tables
skip-character-set-client-handshake = true

[mysql]
socket    = $MYSQL_HOME/mysql.sock
default-character-set = utf8mb4

[client]
default-character-set = utf8mb4
EOF

chown mysql:mysql -R $MYSQL_HOME && \
  cd $MYSQL_HOME && \
  ./bin/mysqld --initialize-insecure --user=mysql \
               --basedir=$MYSQL_HOME \
               --datadir=$MYSQL_HOME/data && \
  ./bin/mysql_ssl_rsa_setup --datadir=$MYSQL_HOME/data

cd $MYSQL_HOME && \
  support-files/mysql.server /etc/init.d/mysql.server &&
  chmod +x /etc/init.d/mysql.server


logi "Starting mysql service"
service mysql.server start


logi "Please login with: $MYSQL_HOME/bin/mysql -uroot"
