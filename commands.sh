conda create -n tf113
source activate tf113

pip download -i https://pypi.tuna.tsinghua.edu.cn/simple -d wheels_tf113 tensorflow-gpu==1.13.1
pip download -i https://pypi.tuna.tsinghua.edu.cn/simple -d wheels_tf200 tensorflow-gpu==2.0.0b1
