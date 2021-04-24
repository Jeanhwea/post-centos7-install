HERE=`cd $(dirname $0); pwd`
INSTALLER=/media/cdrom/database/runInstaller
SYSUSER=${SYSUSER:="system"}
SYSPASS=${SYSPASS:="oracle"}
TOTALMEM=$(grep MemTotal /proc/meminfo | awk '{print $2}')
ORCLMEM=$(expr $TOTALMEM / 2560)

CLRRED="\033[31m"
CLRGRN="\033[32m"
CLRYLW="\033[33m"
CLRBLU="\033[34m"
CLRMGA="\033[35m"
CLRRST="\033[0m"

logi() {
  echo -e "$(date +'%F %T : ') ${CLRYLW}$*${CLRRST}"
}

sudo mount /dev/cdrom /media/cdrom

if [ ! -f $INSTALLER ]; then
  echo "Error: $INSTALLER not found!"
  exit 2
fi

logi "Installing Oracle Database 11g ..."

sed "s/orclmem/${ORCLMEM}/g" ./response/db_install.rsp > /tmp/db_install.rsp \
  && chmod 777 ./response/db_install.rsp

sleep 10 && \
  sudo su - oracle -c "tail -F -n 0 /u01/app/oraInventory/logs/installActions*.log" &

EMAGENT="/u01/app/oracle/product/11.2.0/dbhome_1/sysman/lib/ins_emagent.mk"
FIXCMD="sed -i 's/^\(\s*\$(MK_EMAGENT_NMECTL)\)\s*$/\1 -lnnz11/g' $EMAGENT"
sleep 20 && sudo ls $EMAGENT && logi "fix $EMAGENT" && sudo su - oracle -c "${FIXCMD}" &
sleep 40 && sudo ls $EMAGENT && logi "fix $EMAGENT" && sudo su - oracle -c "${FIXCMD}" &
sleep 60 && sudo ls $EMAGENT && logi "fix $EMAGENT" && sudo su - oracle -c "${FIXCMD}" &
sleep 80 && sudo ls $EMAGENT && logi "fix $EMAGENT" && sudo su - oracle -c "${FIXCMD}" &
sleep 99 && sudo ls $EMAGENT && logi "fix $EMAGENT" && sudo su - oracle -c "${FIXCMD}" &


logi "Invoking Oracle Database 11g ..."
sudo su - oracle -c "$INSTALLER -silent -ignorePrereq -waitforcompletion -responseFile /tmp/db_install.rsp"


logi "Executing root scripts ..."
sudo su - root -c "/u01/app/oraInventory/orainstRoot.sh"
sudo su - root -c "/u01/app/oracle/product/11.2.0/dbhome_1/root.sh"

logi "Executing Post-install tasks ..."
sudo sed -i 's/:N$/:Y/g' /etc/oratab
sudo sed -i 's/# su - oracle/su - oracle/g' /etc/rc.d/rc.local
sudo chmod +x /etc/rc.d/rc.local

sudo su - oracle -c "cd /u01/app/oracle/oradata && mkdir mes && mkdir spot"
