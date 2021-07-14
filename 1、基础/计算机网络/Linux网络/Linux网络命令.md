## 1、命名空间

Linux提供命名空间来实现内核级别的环境隔离，



系统调用

- clone() - 创建一个进程
- unshare() - 使进程加脱离某个namespace
- setns() - 使进程加入某个namespace





## 网络相关命令



### 1、网桥

~~~shell
# 新增网桥(连接两个局域网的虚拟网络设备)
brctl addbr [name]
ip link add name [name] type bridge

# 启用网桥
ip link set [name] up

# 添加设备到网桥
brctl addif [bridge-name] [device-name]

# 查看所有网桥信息
brctl show

# 查看网桥上连接的设备信息
bridge link

# 配置IP
ip addr add 10.20.30.41/24 dev [veth-name]

~~~



### 2、VETH



~~~shell
# 创建veth(虚拟以太网)
ip link add [veth1-0] type veth peer name [veth1-1]

# 查看veth信息
ifconfig [veth-name]



# 改名
ip link set dev [old-veth-name] name [new-veth-name]

# 配置veth的IP/Mask
ip addr add 10.20.30.41/24 dev [veth-name]
# 删除设备的IP/Mask
ip addr del 192.168.3.101/24 dev [device-name]
~~~





### 3、NameSpace

~~~shell
# 新增network namespace 
ip netns add [name]

# 指定network namespace执行命令
ip netns exec zanpocc /bin/bash --rcfile <(echo "PS1=\"namespace ns1> \"")

# 设置veth的namespace
ip link set [veth-name] netns [network-namespace-name]
~~~



### 4、路由/网关

~~~shell
# 查看路由表
route -n

# 设置默认网关
ip route add default via 192.168.3.1
# 添加默认路由网关
route add default gw 172.18.128.1

# 删除路由
route del -net 192.0.0.0 netmask 255.0.0.0

# 查看系统所有网络设备
ip link
~~~



### 5、网络设备信息

~~~shell
# 修改IP、子网掩码、广播地址
ifconfig eth0 192.168.120.56 netmask 255.255.255.0 broadcast 192.168.120.255

# 网络设备重命名
ip link set dev [old-name] name [new-name]

# 启用/禁用网络设备
ip link set dev [veth-name] up
~~~



### 6、查看内核日志

~~~shell
# 查看内核日志
dmesg

# 查看并清空缓冲区
dmesg -c
~~~

