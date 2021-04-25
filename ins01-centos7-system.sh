HERE=`cd $(dirname $0); pwd`

su - root  -c "$HERE/step1-setup-yum-repo.sh"
su - root  -c "$HERE/step2-setup-system.sh"
su - root  -c "$HERE/step3-install-package.sh"
su - root  -c "$HERE/step4-setup-oracle-envs.sh"
su - admin -c "$HERE/step5-bashrc-envs.sh"
