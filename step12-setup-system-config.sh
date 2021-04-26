HERE=`cd $(dirname $0); pwd`
STR_HOSTADDR=$(hostname -I | awk '{ print $1 }')
USERNAME=admin

cat >> /etc/profile <<\EOF
# basic
export EDITOR=vim

# jdk & maven
export JAVA_HOME=/usr/local/java/jdk1.8.0_191
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar${CLASSPATH:+:${CLASSPATH}}
export MAVEN_HOME=/usr/local/java/apache-maven-3.6.3
export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

# python & anaconda
export PYTHONDONTWRITEBYTECODE=1
export PYTHONPATH=.${PYTHONPATH:+:${PYTHONPATH}}
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
export CONDA_HOME=/usr/local/anaconda3
alias py='$CONDA_HOME/bin/python'
alias ipy='$CONDA_HOME/bin/ipython'

# tmux
alias t='tmux list-sessions'
alias ta='tmux attach -t Jinghui || tmux new-session -s Jinghui'
alias td='tmux detach'

# export CUDA_HOME=/usr/local/cuda
# export PATH=$CUDA_HOME/bin${PATH:+:${PATH}}
# export LD_LIBRARY_PATH=$CUDA_HOME/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
EOF


cat >> /etc/profile << EOF
export PEIZHI_URL=http://$STR_HOSTADDR:9000
EOF


################################################################################
# firewall
################################################################################
systemctl stop firewalld.service
systemctl disable firewalld.service


################################################################################
# datetime
################################################################################
timedatectl set-timezone 'Asia/Shanghai'
timedatectl set-ntp yes

timedatectl
# ntpq -p

su - $USERNAME -c "echo 'set completion-ignore-case on' >> ~/.inputrc"


################################################################################
# sudoer
################################################################################
chmod u+w /etc/sudoers
cat >> /etc/sudoers << EOF
# Allow $USERNAME to run any commands
$USERNAME ALL=(ALL) ALL
EOF
chmod u-w /etc/sudoers

# timedatectl set-time "YYYY-MM-DD HH:MM:SS"
