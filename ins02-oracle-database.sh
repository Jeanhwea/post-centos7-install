HERE=`cd $(dirname $0); pwd`
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

for script in $(find "$HERE" -maxdepth 1 -name 'step3*.sh'); do
  logi "Execute file $script"
  su - root -c "$script"
done

su - oracle -c "cd /u01/app/oracle/oradata && mkdir mes && mkdir spot"

for query in $(find "$HERE/queries" -maxdepth 1 -name '*.sql'); do
  logi "Execute file $query"
  su - admin -c "sqlplus -S $SYSUSER/$SYSPASS < $query"
done
