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
brctl addif [device-name]

# 查看网桥信息
brctl show

# 查看网桥上连接的设备信息
bridge link
~~~



### 2、VETH



~~~shell
# 创建veth(虚拟以太网)
ip link add [veth1-0] type veth peer name [veth1-1]

# 查看veth信息
ifconfig [veth-name]

# 启用/禁用网卡
ip link set dev [veth-name] up

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
ip netns exec [network-namespace-name] bash --rcfile <(echo "PS1=\"ns1> \"")

# 设置veth的namespace
ip link set [veth-name] netns [network-namespace-name]
~~~



### 4、路由/网关

~~~shell
# 查看路由表
route -n

# 设置默认网关
ip route add default via 192.168.3.1

# 查看系统所有网络设备
ip link
~~~



