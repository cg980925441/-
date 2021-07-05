# 没有就需要安装下，然后启动对应服务
nmcli dev show

# 查看网卡绑定的IP
ip addr show dev [net-device-name]

# 网卡绑定的IP根据规则送入的kenrnel内
ip route list table all | grep [net-device-name]