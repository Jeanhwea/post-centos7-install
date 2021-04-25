HERE=`cd $(dirname $0); pwd`
ISODIR=~admin/download/iso
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

logi() { echo -e "$(date +'%F %T : ') ${CLRGRN}$*${CLRRST}"; }
logw() { echo -e "$(date +'%F %T : ') ${CLRYLW}$*${CLRRST}"; }
loge() { echo -e "$(date +'%F %T : ') ${CLRRED}$*${CLRRST}"; }

mkdir -p /media/cdrom
if [ -f $ISODIR/p13390677_112040_Linux-x86-64_disk1.iso ]; then
  mount -o loop $ISODIR/p13390677_112040_Linux-x86-64_disk1.iso /media/cdrom
else
  mount /dev/cdrom /media/cdrom
fi

if [ ! -f $INSTALLER ]; then
  loge "Error: $INSTALLER not found!"
  exit 2
fi

logw "Installing Oracle Database 11g ..."

sed "s/orclmem/${ORCLMEM}/g" $HERE/response/db_install.rsp > /tmp/db_install.rsp \
  && chmod 777 /tmp/db_install.rsp

sleep 10 && su - oracle -c "tail -F -n 0 /u01/app/oraInventory/logs/installActions*.log" &

EMAGENT="/u01/app/oracle/product/11.2.0/dbhome_1/sysman/lib/ins_emagent.mk"
FIXCMD="sed -i 's/^\(\s*\$(MK_EMAGENT_NMECTL)\)\s*$/\1 -lnnz11/g' $EMAGENT"
sleep 20 && test -f $EMAGENT && logw "fix $EMAGENT" && su - oracle -c "${FIXCMD}" &
sleep 40 && test -f $EMAGENT && logw "fix $EMAGENT" && su - oracle -c "${FIXCMD}" &
sleep 60 && test -f $EMAGENT && logw "fix $EMAGENT" && su - oracle -c "${FIXCMD}" &
sleep 80 && test -f $EMAGENT && logw "fix $EMAGENT" && su - oracle -c "${FIXCMD}" &
sleep 99 && test -f $EMAGENT && logw "fix $EMAGENT" && su - oracle -c "${FIXCMD}" &


logi "Invoking $INSTALLER ..."
su - oracle -c "$INSTALLER -silent -ignorePrereq -waitforcompletion -responseFile /tmp/db_install.rsp"


logi "Executing root scripts ..."
su - root -c "/u01/app/oraInventory/orainstRoot.sh"
su - root -c "/u01/app/oracle/product/11.2.0/dbhome_1/root.sh"

logi "Executing Post-install tasks ..."
sed -i 's/:N$/:Y/g' /etc/oratab
sed -i 's/# su - oracle/su - oracle/g' /etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local
