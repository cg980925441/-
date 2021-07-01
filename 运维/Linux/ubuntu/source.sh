# 备份
cp -a /etc/apt/sources.list /etc/apt/sources.list.bak

# 替换
sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list
sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list

# 清华arm
sed -i "s@http://cn.ports.ubuntu.com/ubuntu-ports@http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/@g" /etc/apt/sources.list


# 移除cdrom那行
vim /etc/apt/sources.list