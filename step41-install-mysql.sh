HERE=`cd $(dirname $0); pwd`
USERNAME=admin
PACKAGES=~admin/download/packages
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

if [ ! -f $PACKAGES/mysql-5.7.26.tar.gz ]; then
  loge "Error: $PACKAGES/mysql-5.7.26.tar.gz not found!"
  exit 2
fi

logi "Extract package to $MYSQL_HOME ..."
groupadd mysql && \
  useradd -r -g mysql -s /bin/false mysql

cd /usr/local && \
  tar xzf $PACKAGES/mysql-5.7.26.tar.gz && \
  tar xzf $PACKAGES/mysql-boost-5.7.26.tar.gz && \
  chown -R mysql:mysql mysql-5.7.26 && \
  ln -s mysql-5.7.26 mysql

mkdir -p $MYSQL_HOME/data && \
  chown -R mysql:mysql $MYSQL_HOME/data


logi "Configuring, Building and Install ..."
cd $MYSQL_HOME && \
  mkdir bld && cd bld && \
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
        -DWITH_BOOST=$MYSQL_HOME/boost/boost_1_59_0 \
        -DENABLED_LOCAL_INFILE=1 \
        -DMYSQL_TCP_PORT=3306 \
        -DWITH_READLINE=1 \
        -DMYSQL_USER=mysql \
        -DWITH_SSL=yes && \
  make -j 8 && make install

if [ -f /etc/my.cnf ] && [ ! -f /etc/my.cnf.1 ]; then
  logw "Backup /etc/my.cnf"
  mv /etc/my.cnf /etc/my.cnf.1
fi

logi "Initializing Database with configuration ..."

cat >> /etc/my.cnf << EOF
[mysqld]
basedir   = $MYSQL_HOME
datadir   = $MYSQL_HOME/data
socket    = $MYSQL_HOME/mysql.sock
pid-file  = $MYSQL_HOME/mysqld.pid
log-error = $MYSQL_HOME/error.log

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links                  = 0
user                            = mysql
port                            = 3306
bind-address                    = 0.0.0.0
max-connections                 = 1000
character-set-server            = utf8mb4
collation-server                = utf8mb4_unicode_ci
init-connect                    = 'SET NAMES utf8mb4'
explicit-defaults-for-timestamp = true

# skip-grant-tables to reset root password
# skip-grant-tables
skip-character-set-client-handshake = true

[mysql]
default-character-set = utf8mb4
socket                = $MYSQL_HOME/mysql.sock
prompt                = '\u@\h [\d]> '

[client]
default-character-set = utf8mb4
EOF

cat /etc/my.cnf

chown mysql:mysql -R $MYSQL_HOME && \
  cd $MYSQL_HOME && \
  ./bin/mysqld --user=mysql \
               --initialize-insecure \
               --basedir=$MYSQL_HOME \
               --datadir=$MYSQL_HOME/data && \
  ./bin/mysql_ssl_rsa_setup --datadir=$MYSQL_HOME/data

cp $MYSQL_HOME/bld/support-files/mysql.server /etc/init.d/mysql.server &&
  chmod +x /etc/init.d/mysql.server


logi "Starting mysqld service ..."
service mysql.server start

cat >> /etc/rc.d/rc.local << EOF
################################################################################
# mysql
################################################################################
service mysql.server start
EOF
chmod +x /etc/rc.d/rc.local

cat >> /etc/profile <<\EOF
# mysql
export MYSQL_HOME=/usr/local/mysql
export PATH=$MYSQL_HOME/bin${PATH:+:${PATH}}
alias my="$MYSQL_HOME/bin/mysql -uroot"
EOF

read -d '' -r MY_CHEATSHEET_STR << EOF
-- Login with:

  $MYSQL_HOME/bin/mysql -uroot

-- Create database and user using:

  create database test01 default character set utf8mb4 collate utf8mb4_general_ci;
  create user 'test01'@'%' identified by 'test01';
  grant all privileges on test01.* to 'test01'@'%';
  flush privileges;

-- or Make root login remote using:

  use mysql;
  set password = password('root');
  update user set host = '%' where user = 'root';
  flush privileges;

EOF

logw "Cheatsheet :)"
echo "$MY_CHEATSHEET_STR"
