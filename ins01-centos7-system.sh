HERE=`cd $(dirname $0); pwd`
USERNAME=admin

CLRRED="\033[31m"
CLRGRN="\033[32m"
CLRYLW="\033[33m"
CLRBLU="\033[34m"
CLRMGA="\033[35m"
CLRRST="\033[0m"

logi() { echo -e "$(date +'%F %T : ') ${CLRGRN}$*${CLRRST}"; }
logw() { echo -e "$(date +'%F %T : ') ${CLRYLW}$*${CLRRST}"; }
loge() { echo -e "$(date +'%F %T : ') ${CLRRED}$*${CLRRST}"; }

for script in $(find "$HERE" -maxdepth 1 -name 'step1*.sh' | sort); do
  logi "Execute script $script"
  su - root -c "$script"
  [ "$?" != "0" ] && exit 1
done

for script in $(find "$HERE" -maxdepth 1 -name 'step2*.sh' | sort); do
  logi "Execute script $script"
  su - $USERNAME -c "$script"
  [ "$?" != "0" ] && exit 1
done
