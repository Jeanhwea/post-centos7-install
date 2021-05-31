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

for script in $(find "$HERE" -maxdepth 1 -name 'step4*.sh' | sort); do
  logi "Execute script $script"
  su - root -c "$script"
  [ "$?" != "0" ] && exit 1
done

source /etc/profile

for query in $(find "$HERE/queries" -maxdepth 1 -name 'mysql*.sql' | sort); do
  logi "Execute query $query"
  cat $query
  su - $USERNAME -c "/usr/local/mysql/bin/mysql -uroot < $query"
  [ "$?" != "0" ] && exit 1
done
