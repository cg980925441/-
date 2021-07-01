# 安装
apt-get install openssh-server

# 改配置，主要改：root用户运行远程登录/远程登陆端口修改.PermitRootLogin yes
vim /etc/ssh/sshd_config

#重启
/etc/init.d/ssh resart

#ssh高亮
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' ~/.bashrc
source ~/.bashrc
