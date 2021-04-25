HERE=`cd $(dirname $0); pwd`

CLRRED="\033[31m"
CLRGRN="\033[32m"
CLRYLW="\033[33m"
CLRBLU="\033[34m"
CLRMGA="\033[35m"
CLRRST="\033[0m"

logi() { echo -e "$(date +'%F %T : ') ${CLRGRN}$*${CLRRST}"; }
logw() { echo -e "$(date +'%F %T : ') ${CLRYLW}$*${CLRRST}"; }
loge() { echo -e "$(date +'%F %T : ') ${CLRRED}$*${CLRRST}"; }

for script in $(find "$HERE" -maxdepth 1 -name 'step1*.sh'); do
  logi "Execute file $script"
  su - root -c "$script"
done

for script in $(find "$HERE" -maxdepth 1 -name 'step2*.sh'); do
  logi "Execute file $script"
  su - admin -c "$script"
done
