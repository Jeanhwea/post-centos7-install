# 修改主机名
hostnamectl set-hostname centos_113.localadmin

HOSTADDR=$(hostname -I | awk '{print $1}')
HOSTNAME=$(hostname)

echo "$HOSTADDR $HOSTNAME" >> /etc/hosts


# 时间和时区相关操作
timedatectl


# 创建和使用 anaconda 的虚拟环境
conda create --offline -n tf113
source activate tf113

pip download -i https://pypi.tuna.tsinghua.edu.cn/simple -d wheels_tf113 tensorflow-gpu==1.13.1
pip download -i https://pypi.tuna.tsinghua.edu.cn/simple -d wheels_tf200 tensorflow-gpu==2.0.0b1

pip install --no-index --find-link=wheels_tf113 tensorflow-gpu==1.13.1


# 图形界面操作
yum groupinstall "GNOME Desktop" "Graphical Administration Tools"
systemctl get-default
systemctl set-default graphical.target
systemctl set-default multi-user.target
