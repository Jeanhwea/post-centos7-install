HERE=`cd $(dirname $0); pwd`
USERNAME=admin
PACKAGES=~admin/download/packages
PGHOME=/usr/local/pgsql
PGDATA=/usr/local/pgsql/data

CLRRED="\033[31m"
CLRGRN="\033[32m"
CLRYLW="\033[33m"
CLRBLU="\033[34m"
CLRMGA="\033[35m"
CLRRST="\033[0m"

logi() { echo -e "$(date +'%F %T : ') ${CLRGRN}$*${CLRRST}"; }
logw() { echo -e "$(date +'%F %T : ') ${CLRYLW}$*${CLRRST}"; }
loge() { echo -e "$(date +'%F %T : ') ${CLRRED}$*${CLRRST}"; }

if [ ! -f $PACKAGES/postgresql-9.6.19.tar.gz ]; then
  loge "Error: $PACKAGES/postgresql-9.6.19.tar.gz not found!"
  exit 2
fi

logi "Extract package to $PGHOME ..."
groupadd postgres && \
  useradd -g postgres postgres

cd /usr/local && \
  tar xzf $PACKAGES/postgresql-9.6.19.tar.gz && \
  chown -R postgres:postgres postgresql-9.6.19 && \
  ln -s postgresql-9.6.19 pgsql

mkdir -p $PGHOME/data && \
  chown -R postgres:postgres $PGHOME/data


logi "Configuring, Building and Install ..."
cd $PGHOME && \
  ./configure --prefix=$PGHOME && \
  make -j 8 world && \
  make install-world


logi "Initializing Database ..."

su - postgres -c "$PGHOME/bin/initdb -E UTF8 -D $PGDATA"

if [ -f $PGDATA/postgresql.conf ]; then
  sed -i "/listen_addresses/alisten_addresses = '*'" $PGDATA/postgresql.conf
  sed -i "s/max_connections/#max_connections/"       $PGDATA/postgresql.conf
  sed -i "/max_connections/amax_connections = 1000"  $PGDATA/postgresql.conf
  logw "$PGDATA/postgresql.conf"
  cat $PGDATA/postgresql.conf
fi

if [ -f $PGDATA/pg_hba.conf ]; then
  sed -i "/IPv4 local connections/ahost all all 0.0.0.0/0 md5" $PGDATA/pg_hba.conf
  logw "$PGDATA/pg_hba.conf"
  cat $PGDATA/postgresql.conf
fi


logi "Starting postgres server ..."

su - postgres -c "$PGHOME/bin/pg_ctl -D $PGDATA -l $PGDATA/logfile start"

cat >> /etc/rc.d/rc.local << EOF
################################################################################
# postgres
################################################################################
su - postgres -c "/usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l /usr/local/pgsql/data/logfile start"
EOF
chmod +x /etc/rc.d/rc.local

cat >> /etc/profile <<\EOF
# postgres basic envs
export PGHOME=/usr/local/pgsql
export PGDATA=/usr/local/pgsql/data
export PATH=$PGHOME/bin:$PATH
# postgres user and port
export PGUSER=postgres
export PGPORT=5432

# alias for postgres
alias cdph="cd $PGHOME"
alias p0="$PGHOME/bin/pg_ctl stop"
alias p1="$PGHOME/bin/pg_ctl -D $PGDATA -l $PGDATA/logfile start"
EOF

read -d '' -r PG_CHEATSHEET_STR << EOF
-- Login with:

  PGUSER=postgres PGPORT=5432 /usr/local/pgsql/bin/psql

-- Create User using:

  PGUSER=postgres PGPORT=5432 /usr/local/pgsql/bin/createuser -e -d user01

  PGUSER=postgres PGPORT=5432 /usr/local/pgsql/bin/createuser -e --interactive

-- Create Database using:

  PGUSER=postgres PGPORT=5432 /usr/local/pgsql/bin/createdb -e -E UTF8 -O user01 db01

-- Change User Password

  PGUSER=postgres PGPORT=5432 /usr/local/pgsql/bin/psql

  Something like:
    postgres=# \c postgres user01
    You are now connected to database "postgres" as user "user01".
    postgres=> \password
    Enter new password:
    Enter it again:
    postgres=>

  or

    postgres=# alter user user01 PASSWORD '1234';
    ALTER ROLE
    postgres=#

EOF

logw "Cheatsheet :)"
echo "$PG_CHEATSHEET_STR"
