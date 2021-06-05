# dns设置
# 1、临时生效
sudo vim /etc/resolv.conf
# 2、永久生效
sudo vim /etc/resolvconf/resolv.conf.d/base

# 修改为
nameserver 114.114.114.114

# 启用生效
sudo /etc/init.d/networking restart #使网卡配置生效
sudo /etc/init.d/resolvconf restart #使DNS生效


