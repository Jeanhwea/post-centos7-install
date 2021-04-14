# User specific aliases and functions

sed -i '/# User specific aliases and functions/a#<>#' ~/.bashrc
sed -i '/#<>#/,$d' ~/.bashrc

cat >> ~/.bashrc <<\EOF
export PS1='[\u@\h \w]\$ '
alias db='rlwrap sqlplus bamtri_mes/bamtri_mes'
alias de='sqlplus -S bamtri_mes/bamtri_mes'
alias dr='sqlplus -S bamtri_mes/bamtri_mes < '
EOF
