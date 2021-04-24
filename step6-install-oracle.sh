HERE=`cd $(dirname $0); pwd`
INSTALLER=/media/cdrom/database/runInstaller
SYSUSER=${SYSUSER:="system"}
SYSPASS=${SYSPASS:="oracle"}
TOTALMEM=$(grep MemTotal /proc/meminfo | awk '{print $2}')
ORCLMEM=$(expr $TOTALMEM / 2560)

sudo mount /dev/cdrom /media/cdrom

if [ ! -f $INSTALLER ]; then
  echo "Error: $INSTALLER not found!"
  exit 2
fi

sed "s/orclmem/${ORCLMEM}/g" ./response/db_install.rsp > /tmp/db_install.rsp \
  && chmod 777 ./response/db_install.rsp

echo "Installing Oracle Database 11g ..."
sudo su - oracle -c "$INSTALLER -silent -ignorePrereq -waitforcompletion -responseFile /tmp/db_install.rsp"


echo "Executing root scripts"
sudo /u01/app/oraInventory/orainstRoot.sh
sudo /u01/app/oracle/product/11.2.0/dbhome_1/root.sh

echo "Post install tasks"
sudo sed -i 's/# su - oracle/su - oracle/g' /etc/rc.local
sudo sed -i 's/:N$/:Y/g' /etc/oratab
sudo chmod +x /etc/rc.local

sudo su - oracle -c "cd /u01/app/oracle/oradata && mkdir mes && mkdir spot"


read -d '' ORACLE_POST_SETUP_SQL << EOF
--------------------------------------------------------------------------------
-- sysplus / as sysdba
--------------------------------------------------------------------------------
alter system set processes = 1500 scope = spfile;
alter system set sessions = 2272 scope = spfile;
alter system set transactions = 1650 scope = spfile;
alter system set deferred_segment_creation = false scope = both;

--------------------------------------------------------------------------------
-- profiles
--------------------------------------------------------------------------------
-- select * from dba_profiles;
alter profile default limit failed_login_attempts unlimited;
alter profile default limit password_life_time unlimited;
EOF

echo "$ORACLE_POST_SETUP_SQL" | sqlplus -S ${SYSUSER}/${SYSPASS}
