# 安装
apt-get install openssh-server

# 改配置(端口)
vim /etc/ssh/sshd_config

#重启
/etc/init.d/ssh resart

#ssh高亮
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' ~/.bashrc
source ~/.bashrc