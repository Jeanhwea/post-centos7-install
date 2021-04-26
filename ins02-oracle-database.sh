HERE=`cd $(dirname $0); pwd`
USERNAME=admin
SYSUSER=${SYSUSER:="system"}
SYSPASS=${SYSPASS:="oracle"}

CLRRED="\033[31m"
CLRGRN="\033[32m"
CLRYLW="\033[33m"
CLRBLU="\033[34m"
CLRMGA="\033[35m"
CLRRST="\033[0m"

logi() { echo -e "$(date +'%F %T : ') ${CLRGRN}$*${CLRRST}"; }
logw() { echo -e "$(date +'%F %T : ') ${CLRYLW}$*${CLRRST}"; }
loge() { echo -e "$(date +'%F %T : ') ${CLRRED}$*${CLRRST}"; }

for script in $(find "$HERE" -maxdepth 1 -name 'step3*.sh' | sort); do
  logi "Execute script $script"
  su - root -c "$script"
done

su - oracle -c "cd /u01/app/oracle/oradata && mkdir mes && mkdir spot"

for query in $(find "$HERE/queries" -maxdepth 1 -name '*.sql' | sort); do
  logi "Execute query $query"
  cat $query
  su - $USERNAME -c "sqlplus -S $SYSUSER/$SYSPASS < $query"
done
