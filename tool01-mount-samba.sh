HERE=`cd $(dirname $0); pwd`

SAMHOST=192.168.0.201
SAMPATH=开发服务器共享
SAMUSER=Administrator
SAMPASS='asdzxc1234!@#$'
SAMUID=$(id -u admin)
SAMGID=$(id -g admin)
LOCALDIR=/mnt/share

CLRRED="\033[31m"
CLRGRN="\033[32m"
CLRYLW="\033[33m"
CLRBLU="\033[34m"
CLRMGA="\033[35m"
CLRRST="\033[0m"

logi() { echo -e "$(date +'%F %T : ') ${CLRGRN}$*${CLRRST}"; }
logw() { echo -e "$(date +'%F %T : ') ${CLRYLW}$*${CLRRST}"; }
loge() { echo -e "$(date +'%F %T : ') ${CLRRED}$*${CLRRST}"; }

mount_windows_share () {
  [ ! -d $LOCALDIR ] && mkdir -p $LOCALDIR

  MOUNT_STR=$(mount | grep "$LOCALDIR")
  [ "$MOUNT_STR" == "" ] && \
    mount -t cifs //$SAMHOST/$SAMPATH $LOCALDIR \
          -o username=$SAMUSER,password="${SAMPASS}",rw,nounix,iocharset=utf8,uid=$SAMUID,gid=$SAMGID

  MOUNT_RES=$(mount | grep "$LOCALDIR")
  logi "$MOUNT_RES"
}

################################################################################
# main
################################################################################
mount_windows_share
