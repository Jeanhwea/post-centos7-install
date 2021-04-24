#!/usr/bin/env bash
HERE=`cd $(dirname $0); pwd`
CONFFILE=~/.bashrc
HOSTADDR=$(hostname -I | awk '{print $1}')

CLRRED="\033[31m"
CLRGRN="\033[32m"
CLRYLW="\033[33m"
CLRBLU="\033[34m"
CLRMGA="\033[35m"
CLRRST="\033[0m"

CLRHOST=$CLRRED
if [[ "$HOSTADDR" =~ ^192.168.[0-9]+.[0-9]+$ ]]; then
  CLRHOST=$CLRGRN
fi


sed -i '/# User specific aliases and functions/a#<>#' $CONFFILE
sed -i '/#<>#/,$d' $CONFFILE
echo "# Last updated at $(date +'%Y-%m-%d'), DO NOT ADD SCRIPT UNDER THIS LINE!!!" >> $CONFFILE

# add with environment substitute
cat >> $CONFFILE << EOF
export PS1='[${CLRMGA}\t${CLRRST} ${CLRHOST}\u@\h${CLRRST} ${CLRYLW}\w${CLRRST}]\$ '
EOF

# add without environment substitute
cat >> $CONFFILE <<\EOF
alias down='find . -maxdepth 3 -name sc | xargs -I {} bash -c "{} s"'
alias db='rlwrap sqlplus bamtri_mes/bamtri_mes'
alias de='sqlplus -S bamtri_mes/bamtri_mes'
alias dr='sqlplus -S bamtri_mes/bamtri_mes < '
alias gl='git pull'
EOF
