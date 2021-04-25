HERE=`cd $(dirname $0); pwd`

su - root  -c "$HERE/step6-install-oracle.sh"

su - oracle -c "cd /u01/app/oracle/oradata && mkdir mes && mkdir spot"
