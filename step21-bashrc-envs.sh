#!/usr/bin/env bash
HERE=`cd $(dirname $0); pwd`
CONFFILE=~/.bashrc
HOSTADDR=$(hostname -I | awk '{print $1}')

CLRRED="\033[31m"
CLRGRN="\033[32m"
CLRYLW="\033[33m"
CLRBLU="\033[34m"
CLRMGA="\033[35m"
CLRCYN="\033[36m"
CLRRST="\033[0m"

################################################################################
# Detect alert level.
################################################################################
CLRHOST=$CLRGRN
if [[ "$HOSTADDR" =~ ^172.17.17.2[2-5][0-9]$ ]]; then
  CLRHOST=$CLRRED
fi
if [[ "$HOSTADDR" =~ ^172.16.10.[0-9]+$ ]]; then
  CLRHOST=$CLRRED
fi
if [[ "$HOSTADDR" =~ ^192.168.0.14[1-9]+$ ]]; then
  CLRHOST=$CLRMGA
fi


################################################################################
# Removing old configuration.
################################################################################
sed -i '/# User specific aliases and functions/a#<>#' $CONFFILE
sed -i '/#<>#/,$d' $CONFFILE
echo "# Last updated at $(date +'%Y-%m-%d'), DO NOT ADD SCRIPT UNDER THIS LINE!!!" >> $CONFFILE


################################################################################
# Starting add configuration.
################################################################################
# add with environment substitute
cat >> $CONFFILE << EOF
export PS1='${CLRHOST}\u@\h${CLRRST}:${CLRCYN}\w${CLRRST} \$ '
EOF

# add without environment substitute
cat >> $CONFFILE <<\EOF
# add bash history size
export HISTFILESIZE=99999
export HISTSIZE=99999
# export PROMPT_DIRTRIM=2
alias down='find . -maxdepth 3 -name sc | xargs -I {} bash -c "{} s"'
alias loc='echo $USER@$(hostname -I | awk '"'{print \$1}'"'):$PWD'
alias db='rlwrap sqlplus bamtri_mes/bamtri_mes'
alias de='sqlplus -S bamtri_mes/bamtri_mes'
alias dr='sqlplus -S bamtri_mes/bamtri_mes < '
alias gl='git pull'
alias gg='git log --graph --decorate --oneline'
EOF
