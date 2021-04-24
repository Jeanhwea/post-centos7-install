HERE=`cd $(dirname $0); pwd`
INSTALLER=/media/cdrom/database/runInstaller

sudo mount /dev/cdrom /media/cdrom

if [ -f $INSTALLER ]; then
  echo "Error: $INSTALLER not found"
fi

cp ./response/db_install.rsp /tmp

echo "Installing Oracle Database 11g ..."
sudo su - oracle -c "$INSTALLER -silent -ignorePrereq -waitforcompletion -responseFile /tmp/db_install.rsp"


echo "Executing root scripts"
sudo /u01/app/oraInventory/orainstRoot.sh
sudo /u01/app/oracle/product/11.2.0/dbhome_1/root.sh
