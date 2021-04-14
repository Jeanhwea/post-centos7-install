HERE=`cd $(dirname $0); pwd`
CONFFILE=~/.bashrc

sed -i '/# User specific aliases and functions/a#<>#' $CONFFILE
sed -i '/#<>#/,$d' $CONFFILE
echo "# Last updated at $(date +'%Y-%m-%d'), DO NOT ADD SCRIPT UNDER THIS LINE!!!" >> $CONFFILE

cat >> $CONFFILE <<\EOF
export PS1='[\u@\h \w]\$ '
alias db='rlwrap sqlplus bamtri_mes/bamtri_mes'
alias de='sqlplus -S bamtri_mes/bamtri_mes'
alias dr='sqlplus -S bamtri_mes/bamtri_mes < '
EOF
