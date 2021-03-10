# 下载
wget https://download.redis.io/releases/redis-6.0.10.tar.gz

# 编译
make 

# 清除编译
make distclean

# 安装,指定路径
make PREFIX=/opt/zanpocc/redis install

# 添加环境变量
echo "export REDIS_HOME=/opt/zanpocc/redis" >> /etc/profile
echo "export PATH=$PATH:$REDIS_HOME/bin" >> /etc/profile
source /etc/profile

# 安装为服务，utils
./install_server.sh

# 查看服务配置
vim /etc/init.d/redis_6379


# Selected config:
# Port           : 6379
# Config file    : /etc/redis/6379.conf
# Log file       : /var/log/redis_6379.log
# Data dir       : /var/lib/redis/6379
# Executable     : /opt/zanpocc/redis/bin/redis-server
# Cli Executable : /opt/zanpocc/redis/bin/redis-cli